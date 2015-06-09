class UsersController < ApplicationController
  before_filter :authenticate
  # skip_before_action :verify_authenticity_token
  
  # Queries the database for the current user.
  # returns @current_user as a User object
  def show
    @current_user = User.find_by(net_id: current_user.net_id)
  end
end
