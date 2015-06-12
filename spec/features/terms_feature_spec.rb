require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
options = { js_errors: false }
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end

describe 'visiting Term page' do
  let(:user) { create(:user) }
  let(:term) { create(:term) }

  context 'in a general sense' do
    it 'visits the path to terms#show' do
      visit(term_path(term.name))
      expect(current_path).to eq('/terms/' + URI.escape(term.name))
    end
    it 'visits the page and shows the term name' do
      visit(term_path(term.name))
      expect(page).to have_content(term.name)
      expect(page).to have_content(term.definition)
    end
    it 'shows the time term was created_at' do
      visit(term_path(term.name))
      expect(page).to have_content(
        term.created_at.to_datetime.strftime('%a, %d %b %Y %I:%M %p')
      )
    end
  end

  context 'when not logged in' do
    it 'wont show update or delete buttons' do
      visit(term_path(term.name))
      expect(page).to have_no_css('#updateTermButton')
      expect(page).to have_no_css('#deleteTermButton')
    end
  end

  context 'when logged in' do
    it 'will show the update and delete buttons' do
      login
      visit(term_path(term.name))
      expect(page).to have_css('#updateTermButton')
      expect(page).to have_css('#deleteTermButton')
    end
    it 'adds a new term', js: true do
      login
      find('li.has-dropdown').hover
      click_link('termtiny')
      within('#mytiny') do 
        expect(page).to have_content('Add a New Term')
        fill_in('tname', with: 'My New Term')
        click_button('Save Term')
      end
      expect(page).to have_content('General Information')
      expect(page).to have_content('My New Term')
    end
  end
end
