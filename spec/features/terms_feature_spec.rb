require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
# options = { js_errors: false }
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app)
# end

describe 'Term Feature' do
  let(:user) { create(:user) }
  let(:term) { create(:term) }
  after { page.driver.reset! }

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
    it 'visiting page will show the update and delete buttons' do
      login(user)
      visit(term_path(term.name))
      expect(page).to have_css('#updateTermButton')
      expect(page).to have_css('#deleteTermButton')
    end
    it 'adds a new term', js: true do
      login(user)
      find('li.has-dropdown').hover
      click_link('termtiny')
      wait_for_ajax
      within('#mytiny') do
        expect(page).to have_content('Add a New Term')
        fill_in('tname', with: 'My New Term')
        click_button('Save Term')
      end
      wait_for_ajax
      expect(page).to have_content('General Information')
      expect(page).to have_content('My New Term')
      page.driver.reset!
    end
    it 'updates a term', js: true do
      login(user)
      visit(term_path(term.name))
      select "Limited", from: 'access_designation'
      click_button('Update Term')
      wait_for_ajax
      visit(term_path(term.name))
      wait_for_ajax
      expect(page).to have_select('access_designation', selected: 'Limited')
      page.driver.reset!
    end
    it 'updates the term name', js: true do
      login(user)
      visit(term_path(term.name))
      page.execute_script("tinyMCE.get('name').setContent('My Different Title')")
      click_button('Update Term')
      wait_for_ajax
      visit(term_path('My Different Title'))
      wait_for_ajax
      expect(page).to have_content('My Different Title')
      page.driver.reset!
    end
    it 'deletes a term', js: true do
      login(user)
      visit("/terms/#{term.name}")
      wait_for_ajax
      click_button('Delete Term')
      click_button('Yes')
      wait_for_ajax
      expect(page).to_not have_content('General Information')
      expect(page).to_not have_content('Possible Values')
      expect(page).to have_content('My User Name')
      page.driver.reset!
    end
  end
end
