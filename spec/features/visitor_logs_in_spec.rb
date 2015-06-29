require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
# options = { js_errors: false }
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app)
# end

describe 'User Logging In' do
  let(:user) { create(:user) }
  after { page.driver.reset! }
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
    expect(page).to have_content('My User Name')
  end
  it 'will ask to authenticate before taking to user profile' do
    visit('/users/myprofile')
    expect(page).to have_content('Username Password')
  end
  it 'will use the login button to login' do
    visit('/')
    click_link('Log In')
    fill_in 'username', with: user.net_id
    fill_in 'password', with: 'any password'
    click_button 'Login'
    expect(page).to have_content('My User Name')
    expect(page).to have_content(user.net_id)
  end
  it 'switches from logged in to logged out', js: true do
    visit('/')
    click_link('Log In')
    fill_in 'username', with: user.net_id
    fill_in 'password', with: 'any password'
    click_button 'Login'
    expect(page).to have_content('My User Name')
    find('li.has-dropdown').hover
    click_link('Log Out')
    expect(page).to have_content('Welcome To The BI Portal')
    expect(page).to have_content('Log In')
  end
end
