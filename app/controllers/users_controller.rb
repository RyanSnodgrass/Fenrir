# Authenticates you before redirecting you to the user's show page
class UsersController < ApplicationController
  before_filter :authenticate

  def show
  end
end
