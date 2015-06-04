require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
options = { js_errors: false }
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end

describe 'some stuff which requires js' do

  it 'will visit an external webpage', :js => true do
    visit("http://example.com")
    expect(page).to have_content("Example Domain")
  end

  # it 'will visit a more complicated webpage', :js => true do
  #   visit("http://foundation.zurb.com/")
  #   expect(page).to have_content("The most advanced responsive front-end framework in the world.")
  # end

  # it "will visit my app's root page" do 
  #   visit('/')
  #   expect(page).to have_content("Welcome To The BI Portal")
  #   page.driver.reset!
  # end

  # it 'will visit a second website with ssl and not raise timeout errors' do
  #   visit("https://github.com/")
  #   expect(page).to have_content("2015 GitHub, Inc.")
  #   page.driver.reset!
  #   # This worked last time I did it. Was very pleased
  #   # it's saved in the parent 'apps' folder holding huginn and muninn
  #   # save_screenshot('../test/tmp/cache/assets/test/file.png')
  # end

  # it 'will visit a third website with ssl and not raise timeout errors', :js => true do
  #   visit("https://www.creditkarma.com/")
  #   expect(page).to have_content("Credit Karma")
  # end

  # it 'finds muninn api is running' do
  #   muninn_url = 'http://' + ENV["muninn_host"] + ':' + ENV["muninn_port"]+ '/'
  #   visit(muninn_url)
  #   expect(page).to have_content('Welcome aboard You’re riding Ruby on Rails!')
  # end
end