require 'rails_helper'

RSpec.describe SessionController do
  let(:user) { create(:user) }
  context 'login' do
    it "will login and redirect to '/users/myprofile'" do
      establish_current_user(user)
      get :foo
      expect(response).to redirect_to('/users/myprofile')
    end
  end
  context 'logout' do
    it 'will logout current user' do
      establish_current_user(user)
      get :logout
      expect(subject.current_user).to be_a_kind_of(AnonymousUser)
    end
    it 'will redirect_to root' do
      establish_current_user(user)
      get :logout
      expect(response).to redirect_to(root_path)
    end
  end
end
