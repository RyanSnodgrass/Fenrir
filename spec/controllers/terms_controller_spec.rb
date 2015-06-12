require 'rails_helper'

RSpec.describe TermsController do
  let(:term) { create(:term) }
  let(:user) { create(:user) }
  describe 'GET show' do
    let(:term) { create(:term) }
    it 'routes to show' do
      get :show, id: term.name
      expect(response.status).to eq(200)
    end
    it 'assigns a term' do
      get :show, id: term.name
      expect(assigns(:term)).to eq(term)
    end
  end
  describe 'POST create' do
    it 'requires authentication' do
      post :create, term: term
      expect(response.status).to eq(401)
    end
    it 'routes to Post#create' do
      establish_current_user(user)
      expect{
        post :create, term: attributes_for(:term)
      }.to change(Term, :count).by(1)
    end
    xit 'redirects to the last term' do
      establish_current_user(user)
      my_term = build(:term)
      post :create, term: attributes_for(my_term)
      expect(response.body).to eq(my_term.json)
    end
    it 'renders status 200' do
      establish_current_user(user)
      post :create, term: attributes_for(:term)
      # expect(response).to respond_with_content_type :html
      expect(response.code).to eq('200')
    end
  end
end
