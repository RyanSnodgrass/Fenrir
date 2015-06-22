class SessionController < ApplicationController
  before_filter :authenticate, only: :foo

  def logout
    session.clear
    current_user = nil
    redirect_to root_path
  end

  def foo
    redirect_to '/users/myprofile'
  end
end
