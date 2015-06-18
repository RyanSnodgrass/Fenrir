require 'rails_helper'
# require 'json'
RSpec.describe TermsController do
  let(:term) { create(:term) }
  let(:user) { create(:user) }
  describe 'GET show' do
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
    it 'adds term to database' do
      establish_current_user(user)
      expect{
        post :create, term: attributes_for(:term)
      }.to change(Term, :count).by(1)
    end
    it "won't add the term without authentication" do
      expect{
        post :create, term: attributes_for(:term)
      }.to change(Term, :count).by(0)
    end
    it 'returns back the added term' do
      establish_current_user(user)
      @term = attributes_for(:term,
        name: 'Academic Year'
      )
      post :create, term: @term
      expect(assigns(:term).name).to eq('Academic Year')
    end
    it 'renders status 200' do
      establish_current_user(user)
      post :create, term: attributes_for(:term)
      expect(response.code).to eq('200')
    end
  end
  describe 'PUT update' do
    it 'requires authentication' do
      put :update, term: term, id: term.name
      expect(response.status).to eq(401)
    end
    it 'located the requested term' do
      # establish_current_user(user)
      put :update, id: term.name, term: attributes_for(:term)
      expect(assigns(:term)).to eq(term)
    end
    it 'updates term in database' do
      establish_current_user(user)
      @term = create(:term)
      expect(@term.name).to_not eq('Academic Year')
      expect(@term.definition).to_not eq('Lorem Ipsum')
      my_changed_term = attributes_for(
        :term, name: 'Academic Year', definition: 'Lorem Ipsum')
      put :update, id: @term.name, term: my_changed_term
      @term.reload
      expect(@term.name).to eq('Academic Year')
      expect(@term.definition).to eq('Lorem Ipsum')
      expect(assigns(:term).name).to eq('Academic Year')
    end
    it "won't update the term without authentication" do
      @term = create(:term)
      put :update, id: @term.name, term: attributes_for(
        :term, name: 'Academic Year', definition: 'Lorem Ipsum')
      @term.reload
      expect(@term.name).to_not eq('Academic Year')
      expect(@term.definition).to_not eq('Lorem Ipsum')
    end
  end
end
