require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
# options = { js_errors: false }
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app)
end

describe 'visiting Term page' do
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
      page.driver.reset!
    end
    it 'updates a term', js: true, focus: true do
      login
      visit(term_path(term.name))
      # page.execute_script('$(tinymce.editors[2].setContent("my content here"))')
      select "Limited", from: 'access_designation'
      click_button('Update Term')
      visit(term_path(term.name))
      save_screenshot('../test/tmp/cache/assets/test/tinymce.png')
      expect(page).to have_select('access_designation', selected: 'Limited')
      page.driver.reset!
      # save_screenshot('../test/tmp/cache/assets/test/tinymce.png')

      # expect(page).to have_content('my content here')
      # page.execute_script('$("#name.editable").tinymce().setContent("Pants are pretty sweet.")')
    end
    it 'deletes a term', js: true do
      login
      visit("/terms/#{term.name}")
      click_button('Delete Term')
      click_button('Yes')
      expect(page).to_not have_content("#{term.name}")
      expect(page).to have_content('My User Name')
      page.driver.reset!
    end
  end
end
