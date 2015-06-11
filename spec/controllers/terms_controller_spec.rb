require 'rails_helper'

RSpec.describe TermsController do
  describe 'GET show' do
    let(:term) { create(:term) }
    it "routes to show" do
      get :show, id: term.name
      expect(response.status).to eq(200)
    end
    it 'assigns a term' do
      get :show, id: term.name
      expect(assigns(:term)).to eq(term)
    end
  end
end
