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
    it 'assigns all permission groups' do
      get :show, id: term.name
      pg = create(:permission_group)
      expect(assigns(:permission_groups)).to eq([pg])
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
    it 'updates a term with a permission group association' do
      establish_current_user(user)
      @term = create(:term)
      @pg = create(:permission_group)
      expect(@term.permission_group).to eq(nil)
      my_changed_term = attributes_for(
        :term, name: 'Academic Year')
      put :update, id: @term.name, term: {
        name: 'Academic Year', perm_group: @pg.name 
      }
      @term.reload
      expect(@term.permission_group).to eq(@pg)
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

  describe 'DELETE destroy' do
    it 'requires authentication' do
      delete :destroy, term: term, id: term.name
      expect(response.status).to eq(401)
    end
    it 'finds the specific term' do
      delete :destroy, term: term, id: term.name
      expect(assigns(:term)).to eq(term)
    end
    it 'deletes a term in the database' do
      establish_current_user(user)
      @term = create(:term)
      expect{
        delete :destroy, term: @term, id: @term.name
      }.to change(Term,:count).by(-1)
    end
  end

  describe 'POST search' do
    it 'returns with a partial template' do
      @term = create(:term)
      get :search, { search_query: @term.name }
      expect(response).to render_template(:partial => '_partial_search')
    end
    it 'returns a search result class in the search results' do
      @term = create(:term)
      # @term.reindex
      # Term.reindex
      Term.searchkick_index.refresh
      get :search, { search_query: @term.name }
      expect(assigns(:results)).to be_a_kind_of(Searchkick::Results)
      expect(assigns(:results).first.name).to eq(@term.name)
    end
  end
end
