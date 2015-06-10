require 'rails_helper'

RSpec.describe UsersController do
  describe 'GET show' do
    let(:user) { create(:user) }
    it 'you must be authenticated before' do
      get :show
      expect(response.status).to eq(401)
    end
    it 'renders the users show page' do
      establish_current_user(user)
      get :show
      expect(response).to render_template('show')
    end
  end
end
