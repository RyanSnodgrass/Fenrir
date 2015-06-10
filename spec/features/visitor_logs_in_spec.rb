require 'rails_helper'
require 'capybara/rails'
# require 'rack/fake_cas'
describe 'User Logging In'do
  let(:user) { create(:user) }
  it "will first visit my app's root page" do
    visit('/')
    expect(page).to have_content('Welcome To The BI Portal')
    expect(page).to have_content('Log In')
  end

  it 'can take them to their profile' do
    visit('/users/myprofile')
    fill_in 'username', with: user.net_id
    fill_in 'password', with: 'any password'
    click_button 'Login'
    expect(page).to have_content('My Security Roles')
    expect(page).to have_content(user.net_id)
  end
  it 'will ask to authenticate before taking to user profile' do
    visit('/users/myprofile')
    expect(page).to have_content('Username Password')
  end
end
