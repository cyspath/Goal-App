require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  it "has a new user page" do
    visit(new_user_url)
    expect(page).to have_content("Sign Up")
  end

  feature "signing up a user" do

    let(:new_user1) { build (:user)}

    before(:each) do
      visit(new_user_url)
      fill_in("Email", with: new_user1.email)
      fill_in("Password", with: new_user1.password)
      click_button("Sign Up!")
    end


    it "shows email on the homepage after signup" do
      expect(page).to have_content(new_user1.email)
    end

  end

end

feature "logging in" do

  let(:new_user2) { create (:user)}

  before(:each) do
    visit(new_session_url)
    fill_in("Email", with: new_user2.email)
    fill_in("Password", with: new_user2.password)
    click_button("Sign In!")
  end

  it "redirects to user's show page" do
    expect(current_path).to match(/^\/users\/(\d)+/)
  end

  it "shows email on the homepage after login" do
    expect(page).to have_content(new_user2.email)
  end

  it 'shows logout button on the show page' do
    expect(page).to have_button 'Sign Out'
  end

end

feature "logging out" do
  let(:new_user3) { create (:user)}

  it "begins with logged out state" do
    visit(new_session_url)
    expect(page).not_to have_content(new_user3.email)
  end

  it "cannot visit user show page when not logged in" do
    visit(user_url(new_user3))

    # redirect to login page
    expect(page).to have_content("Sign In!")
  end

  before(:each) do
    visit(new_session_url)
    fill_in("Email", with: new_user3.email)
    fill_in("Password", with: new_user3.password)
    click_button("Sign In!")

    click_button("Sign Out")
  end

  it "doesn't show email on the homepage after logout" do
    expect(page).not_to have_content(new_user3.email)
  end

  it "redirect's to sign in page" do
    expect(current_path).to match(/^\/session\/new/)
  end
end
