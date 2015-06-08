require 'rails_helper'

# `session` is an actual object but
# session[:cas] variable looks like this
# session[:cas]
# =>
#   {"user"=>"rsnodgra", "ticket"=>"ST-516271-B9XA0vT6ncxmPgzDsUKt-cas", "extra_attributes"=>{}}
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
      render :nothing => true
    end
  end
  let(:user) { create(:user) }
  context 'without CAS' do

    it 'will render 401 without a session' do
      get :index # <= Need this before setting expectation below
      expect(response.status).to eq(401)
    end
  end

  context 'with CAS' do
    it 'will respond with 200 with CAS session' do
      establish_current_user(user)
      expect(response.status).to eq(200)
    end
  end

  context 'current_user helper method' do
    # it 'passing in a nonexistant user, will return anonymous' do
    #   anon = create(:anonymous)
    #   na = User.new
    #   na.net_id = 'nonexistant'
    #   establish_current_user(na)
    #   expect(subject.current_user.net_id).to eq(anon.net_id)
    # end
    # it 'passing in valid existing user, returns that user' do
    #   anon = create(:anonymous)
    #   my_user = create(:user)
    #   establish_current_user(my_user)
    #   expect(subject.current_user.net_id).to eq(my_user.net_id)
    # end
  end
end






















