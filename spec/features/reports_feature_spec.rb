require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

describe 'Report Page' do
  let(:user)   { create(:user) }
  let(:report) { create(:report) }
  after { page.driver.reset! }

  context 'has these things' do
    it 'such as name and description' do
      visit(report_path(report.name))
      expect(page).to have_content(report.name)
      expect(page).to have_content(report.description)
    end
  end
  # it 'switches between edit and view mode', js: true, focus: true do
  #   visit(report_path(report.name))
  #   save_screenshot('../test/tmp/cache/assets/test/file.png')
  #   check('#editmode')
  # end
end
