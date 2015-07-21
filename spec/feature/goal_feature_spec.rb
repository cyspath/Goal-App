require 'spec_helper'
require 'rails_helper'
require 'byebug'

### CREATE GOAL ###
feature "Creating a goal" do
  before(:each) do
    bill_gates = create(:bill_gates)
    sign_up(bill_gates)
  end

  it "user's show page can create a goal" do
    expect(page).to have_link('Create Goal')
  end

  feature "New goal page" do

    before :each do
      click_link "Create Goal"
    end

    it "has title and description fields" do
      expect(page).to have_content "Title"
      expect(page).to have_content "Description"
    end

    #have radio buttons
    it "has a private option" do
      expect(page).to have_content "Private"
      expect(page).to have_content "Public"
    end

    it "goes to the goal show page upon submit" do
      become_pokemon_master
      expect(current_path).to match(/^\/goals\/(\d)+/)
    end

  end

end

### SHOW PAGE - GOAL ###
feature "the goal's show page" do
  before(:each) do
    bill_gates = create(:bill_gates)
    sign_up(bill_gates)
    click_link "Create Goal"
    become_pokemon_master
  end

  it "has goal's title" do
    expect(page).to have_content("Become a pokemon master")
  end

  it "has a description of the goal" do
    expect(page).to have_content("capture pikachu")
  end

  it "should have a link to its author's page" do
    expect(page).to have_link("Back to all goals")
  end

end

### SHOW PAGE - USER ###
feature "the user's show page" do

  let(:bill_gates) { create(:bill_gates) }

  before(:each) do
    sign_in(bill_gates)
    click_link "Create Goal"
    become_pokemon_master
    click_link("Back to all goals")
    click_link("Create Goal")
    create_goal("Conquer Apple", "Sabotage Apple HQ", "Private")
    click_link("Back to all goals")

  end

  it "has user's goals" do
    expect(page).to have_content("Become a pokemon master")
    expect(page).to have_content("Conquer Apple")
  end

  it "only shows the public goals to other users" do

    click_button("Sign Out")
    steve_jobs = create(:user)
    sign_up(steve_jobs)

    visit(user_url(bill_gates))

    expect(page).to have_content("Become a pokemon master")
    expect(page).to_not have_content("Conquer Apple")
  end

end
