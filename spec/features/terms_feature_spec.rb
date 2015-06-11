require 'rails_helper'
require 'capybara/rails'
describe 'visiting Term page'do
  let(:user) { create(:user) }
  let(:term) { create(:term) }
  context 'in a general sense' do
    it 'visits the path to terms#show' do
      visit(term_path(term.name))
      expect(current_path).to eq('/terms/' + URI::encode(term.name))
    end
    it 'visits the page and shows the term name' do
      visit( term_path(term.name))
      expect(page).to have_content(term.name)
      expect(page).to have_content(term.definition)
    end
    it 'shows the time term was created_at' do
      visit(term_path(term.name))
      expect(page).to have_content(
        term.created_at.to_datetime.strftime("%a, %d %b %Y %I:%M %p"))
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
        visit('/users/myprofile')
        fill_in 'username', with: user.net_id
        fill_in 'password', with: 'any password'
        click_button 'Login'
        visit(term_path(term.name))
        expect(page).to have_css('#updateTermButton')
        expect(page).to have_css('#deleteTermButton')
      end
    end
  end
end
