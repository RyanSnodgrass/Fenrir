require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
# options = { js_errors: false }
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, options)
# end

describe 'some stuff which requires js' do
  it 'checks js driver is working by visitin an external webpage', js: true do
    visit('http://example.com')
    expect(page).to have_content('Example Domain')
  end

  # it 'will visit a more complicated webpage', :js => true do
  #   visit("http://foundation.zurb.com/")
  #   expect(page).to have_content("The most advanced responsive front-end")
  # end

  # it 'will visit a second website with ssl and not raise timeout errors' do
  #   visit("https://github.com/")
  #   expect(page).to have_content("2015 GitHub, Inc.")
  #   page.driver.reset!
  #   # This worked last time I did it. Was very pleased
  #   # it's saved in the parent 'apps' folder holding huginn and muninn
  #   # save_screenshot('../test/tmp/cache/assets/test/file.png')
  # end

  # it 'can visit a website with ssl and not raise errors', :js => true do
  #   visit("https://www.creditkarma.com/")
  #   expect(page).to have_content("Credit Karma")
  # end
end
