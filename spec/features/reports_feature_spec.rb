require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
options = { window_size: [1300, 800] }
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
describe 'Report Page' do
  let(:user)   { create(:user) }
  let(:report) { create(:report) }
  after { page.driver.reset! }

  context 'has these things' do
    it 'such as name and description' do
      login(user)
      visit(report_path(report.name))
      expect(page).to have_content(report.name)
      expect(page).to have_content(report.description)
    end
    it 'has photos' do
      login(user)
      visit(report_path(report.name))
      expect(page).to have_content('Sample Image')
      expect(page).to have_selector('img')
    end
    it 'has terms', js: true, focus: true do
      login(user)
      @report = create(:report)
      t = create(:term)
      @report.terms << t
      visit(report_path(@report.name))
      expect(page).to have_content('Data Governance Terms')
      expect(page).to have_content(@report.terms.first.name)
      check "editmode"
      within('ul.select2-choices') do
        expect(page).to have_selector('li.select2-search-choice', text: @report.terms.first.name)
      end
    end
  end

  ## inorder for check boxes to be available, you have to wrap the input
  ## tags in a 'fieldset' tag. check the docs at 
  ## http://foundation.zurb.com/docs/components/switch.html#accessibility
  it 'switches between edit and view mode', js: true do
    login(user)
    visit(report_path(report.name))
    expect(page).to have_no_css('#updateReportButton')
    expect(page).to have_no_css('#deleteReportButton')
    check "editmode"
    expect(page).to have_css('#updateReportButton')
    expect(page).to have_css('#deleteReportButton')
    uncheck "editmode"
    expect(page).to have_no_css('#updateReportButton')
    expect(page).to have_no_css('#deleteReportButton')
  end
  it 'creates a report', js: true do
    login(user)
    visit '/'
    find('li.has-dropdown').hover
    click_link('newreportlink')
    wait_for_ajax
    within('#newreportmodal') do
      expect(page).to have_content('Add New Report')
      fill_in('rname', with: 'My New Report')
      click_button('Save Report')
    end
    wait_for_ajax
    expect(page).to have_css('.reports.show')
    expect(page).to have_content('My New Report')
  end
  it 'updates report', js: true do
    login(user)
    visit(report_path(report.name))
    check "editmode"
    find('#name-edit').set('My Different Name')
    page.execute_script("tinyMCE.get('description').setContent('My Description here')")
    click_button('Update Report')
    expect(page).to have_content('My Different Name')
    expect(page).to have_content('My Description here')
  end
  it 'deletes report', js: true do
    login(user)
    @report = create(:report)
    visit(report_path(@report.name))
    check "editmode"
    click_button('Delete Report')
    click_button('Yes')
    wait_for_ajax
    expect(page).to have_content('My User Name')
    expect(@report).to_not exist
  end

  ## Create method here
end
