require 'spec_helper'
require 'rails_helper'

feature "commenting on goals" do

  let(:bob) { create(:user) }
  before :each do
    sign_in(bob)
    become_pokemon_master
  end

  it "goal's page has a form to submit comments" do
    #check for fields and button
    expect(page).to have_content("Add Comment")
    expect(page).to have_button("Add Comment")
  end

  before :each do
    fill_in("Add Comment", with: "Great goal!")
    click_button("Add Comment")
  end

  it "redirects to the goal's page after submit" do
    #check for correct goal show page url
    expect(current_path).to match(/^\/goals\/(\d)+/)
  end

  it "shows the comment after submit" do
    #expect page to have comment just submitted
    expect(page).to have_content("Great goal!")
  end

  it "must be logged in to comment on goals" do
    sign_out(bob)
    visit_page(goals_url(1))
    click_button("Add Comment!")
    expect(page).to have_content("Must be logged in")
  end
end

feature "commenting on users" do

  let(:mary) { create(:user) }
  let(:joe) { create(:user) }

  before :each do
    sign_in(joe)
    visit_page(user_url(mary))
  end

  it "user's page has a form to submit comments" do
    #check for fields and button
    expect(page).to have_content("Add Comment")
    expect(page).to have_button("Add Comment")
  end

  before :each do
    fill_in("Add Comment", with: "You rock!")
    click_button("Add Comment")
  end

  it "redirects to the user's page" do
    #check for correct user show page url
    expect(current_path).to match(/^\/users\/(\d)+/)
  end

  it "user's page shows the comment after submit" do
    #expect page to have comment just submitted
    expect(page).to have_content("You rock!")
  end

end

feature "editing comments" do

  let(:maggie) { create(:user) }
  let(:jonathan) { create(:user) }

  it "user's page should have link to edit comments" do
    sign_in(jonathan)
    visit_page(user_url(maggie))
    create_comment("I miss you <3")
    expect(page).to have_link("Edit Comment")
  end

  before :each do
    sign_in(jonathan)
    click_link "Create New Goal"
    become_pokemon_master
    click_button "Sign Out"
    sign_in(maggie)
    visit_page(goal_url(1))
    create_comment("Well good luck.")
  end

  it "goal's page should have link to edit comments" do
    expect(page).to have_link("Edit Comment")
  end

  it "should update the page after editing to reflect the changes" do
    click_link "Edit Comment"
    fill_in("Edit Comment", with: "I meant to say, you can do it!")
    click_button "Edit Comment"
    expect(page).to have_content("I meant to say, you can do it!")
  end

  it "should only allow edits on author's own comments" do
    click_button "Sign Out"
    visit_page(goal_url(1))
    expect(page).to_not have_link("Edit Comment")
  end

end
