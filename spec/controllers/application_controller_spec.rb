require 'rails_helper'

# `session` is an actual object but
# session[:cas] variable looks like this
# session[:cas]
# =>
#   { "user"=>"rsnodgra",
#     "ticket"=>"ST-516271-B9XA0vT6ncxmPgzDsUKt-cas",
#     "extra_attributes"=>{}}
#
# Which would then look like
# cas:
#   {
#     user: "rsnodgra"
#   }
RSpec.describe ApplicationController do
  controller do
    before_action :authenticate
    def index
      render nothing: true
    end
  end
  let(:user) { create(:user) }
  context 'authenticate before filter without CAS' do
    it 'will render 401 without a session' do
      get :index # <= Need this before setting expectation below
      expect(response.status).to eq(401)
    end
  end

  context 'authenticate before filter with CAS' do
    it 'will respond with 200 with CAS session' do
      establish_current_user(user)
      expect(response.status).to eq(200)
    end
  end

  describe 'current_user set method' do
    context 'when not logged in' do
      it 'will return anonymous user class' do
        expect(subject.current_user).to be_a_kind_of(AnonymousUser)
      end
      it 'has access to AnonymousUser class methods' do
        expect(subject.current_user.can(:anything)).to eq(false)
        expect(subject.current_user.logged_in?).to eq(false)
        expect(subject.current_user.net_id).to eq('anonymous')
      end
    end
    context 'when logged in' do
      it 'will return User class' do
        establish_current_user(user)
        expect(subject.current_user).to be_a_kind_of(User)
      end
      it 'has access to User class methods' do
        establish_current_user(user)
        expect(subject.current_user.can(:anything)).to eq(true)
        expect(subject.current_user.logged_in?).to eq(true)
      end
    end
    context 'logged in, but nonexistent' do
      it 'when logged in but nonexistent, returns NonExistentUser' do
        na = build(:user)
        establish_current_user(na)
        expect(subject.current_user).to be_a_kind_of(NonExistentUser)
      end
    end
    context 'switches appropriately' do
      it 'when logging in to out ' do
        establish_current_user(user)
        expect(subject.current_user).to be_a_kind_of(User)
        session.delete('cas')
        expect(subject.current_user).to be_a_kind_of(AnonymousUser)
      end
    end
  end
end
