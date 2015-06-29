# documentation
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def authenticate
    unless request.session.key?('cas')
      render status: 401, text: ''
    end
  end

  def current_user
    if session.key?('cas')
      @current_user ||= User.find_by(net_id: session['cas']['user']) || NonExistentUser.new
    else
      @current_user ||= AnonymousUser.new
    end
  end

  helper_method :current_user
end
