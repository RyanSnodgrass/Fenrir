require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
# options = { js_errors: false }
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app)
end

describe 'visiting Permission Group page' do
  let(:user) { create(:user) }
  let(:pg) { create(:permission_group) }
  after { page.driver.reset! }

  context 'in a general sense' do
    it 'visits the path to permission_groups#show' do
      visit(permission_group_path(pg.name))
      expect(current_path).to eq('/permission_groups/' + URI.escape(pg.name))
    end
    it 'visits the page and shows the permission_group name' do
      visit(permission_group_path(pg.name))
      expect(page).to have_content(pg.name)
    end
  end
  context 'when not logged in' do
    it 'wont show update or delete buttons' do
      visit(permission_group_path(pg.name))
      expect(page).to have_no_css('#update-permission-group')
      expect(page).to have_no_css('#update-permission-group')
    end
  end
    context 'when logged in' do
    it 'will show the update and delete buttons' do
      login(user)
      visit(permission_group_path(pg.name))
      expect(page).to have_css('#update-permission-group')
      expect(page).to have_css('#update-permission-group')
    end
    it 'adds a new permission_group', js: true do
      login(user)
      find('li.has-dropdown').hover
      click_link('addpglink')
      within('#permissiongrouptiny') do
        expect(page).to have_content('Register New Permission Group')
        fill_in('pgname', with: 'My New Permission Group')
        click_button('Save Permission Group')
      end
      save_screenshot('../test/tmp/cache/assets/test/permgroup.png')
      expect(page).to have_content('My New Permission Group')
      expect(page).to have_css('#update-permission-group')
      # page.driver.reset!
    end
    it 'updates a permission group', js: true do
      login(user)
      visit(permission_group_path(pg.name))
      page.execute_script("tinyMCE.get('name').setContent('My Different Title')")
      click_button('Update Permission Group')
      visit(permission_group_path('My Different Title'))
      expect(page).to have_content('My Different Title')
      # page.driver.reset!
    end
    it 'deletes a permission group', js: true do
      login(user)
      visit(permission_group_path(pg.name))
      click_button('Delete Permission Group')
      click_button('Yes')
      expect(page).to_not have_content(pg.name)
      expect(page).to have_content('My User Name')
    end
  end
end
