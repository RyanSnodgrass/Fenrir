require 'rails_helper'
# require 'json'
RSpec.describe PermissionGroupsController do
  let(:permission_group) { create(:permission_group) }
  let(:user) { create(:user) }
  describe 'GET show' do
    it 'routes to show' do
      get :show, id: permission_group.name
      expect(response.status).to eq(200)
    end
    it 'assigns a permission_group' do
      get :show, id: permission_group.name
      expect(assigns(:permission_group)).to eq(permission_group)
    end
  end
  describe 'POST create' do
    it 'requires authentication' do
      post :create, permission_group: permission_group
      expect(response.status).to eq(401)
    end
    it 'adds permission_group to database' do
      establish_current_user(user)
      expect{
        post :create, permission_group: attributes_for(:permission_group)
      }.to change(PermissionGroup, :count).by(1)
    end
    it "won't add the permission group without authentication" do
      expect{
        post :create, permission_group: attributes_for(:permission_group)
      }.to change(PermissionGroup, :count).by(0)
    end
    it 'returns back the added permission_group' do
      establish_current_user(user)
      @permission_group = attributes_for(:permission_group,
        name: 'Sergeant Peppers Lonely Hearts Club Band'
      )
      post :create, permission_group: @permission_group
      expect(assigns(:permission_group).name).to eq('Sergeant Peppers Lonely Hearts Club Band')
    end
    it 'renders status 200' do
      establish_current_user(user)
      post :create, permission_group: attributes_for(:permission_group)
      expect(response.code).to eq('200')
    end
  end
  describe 'PUT update' do
    it 'requires authentication' do
      put :update, permission_group: permission_group, id: permission_group.name
      expect(response.status).to eq(401)
    end
    it 'located the requested permission_group' do
      # establish_current_user(user)
      put :update, permission_group: permission_group, id: permission_group.name
      expect(assigns(:permission_group)).to eq(permission_group)
    end
    it 'updates permission_group in database' do
      establish_current_user(user)
      @permission_group = create(:permission_group)
      expect(@permission_group.name).to_not eq('Sergeant Peppers Lonely Hearts Club Band')
      my_changed_permission_group = attributes_for(
        :permission_group, name: 'Sergeant Peppers Lonely Hearts Club Band')
      put :update, id: @permission_group.name, permission_group: my_changed_permission_group
      @permission_group.reload
      expect(@permission_group.name).to eq('Sergeant Peppers Lonely Hearts Club Band')
      expect(assigns(:permission_group).name).to eq('Sergeant Peppers Lonely Hearts Club Band')
    end
    it "won't update the permission_group without authentication" do
      @permission_group = create(:permission_group)
      put :update, id: @permission_group.name, permission_group: attributes_for(
        :permission_group, name: 'Sergeant Peppers Lonely Hearts Club Band')
      @permission_group.reload
      expect(@permission_group.name).to_not eq('Sergeant Peppers Lonely Hearts Club Band')
    end
  end
  describe 'DELETE destroy' do
    it 'requires authentication' do
      delete :destroy, permission_group: permission_group, id: permission_group.name
      expect(response.status).to eq(401)
    end
    it 'finds the specific permission_group' do
      delete :destroy, permission_group: permission_group, id: permission_group.name
      expect(assigns(:permission_group)).to eq(permission_group)
    end
    it 'deletes a permission_group in the database' do
      establish_current_user(user)
      @permission_group = create(:permission_group)
      expect{ 
        delete :destroy, permission_group: @permission_group, id: @permission_group.name
      }.to change(PermissionGroup,:count).by(-1)
    end
  end
end
