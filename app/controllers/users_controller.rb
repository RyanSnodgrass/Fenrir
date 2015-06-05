class UsersController < ApplicationController
  before_filter :authenticate
  # skip_before_action :verify_authenticity_token
  def show
    @user = User.find_by(net_id: current_user.net_id)
  end
end
