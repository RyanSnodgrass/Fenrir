class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter CASClient::Frameworks::Rails::Filter

  def authenticate!
    if !request.session.has_key?("cas")
      render status: 401, text: ""
    end
  end

  def current_user
    @current_user ||= cas_user
  end

  def cas_user
    
    if ( session.has_key?(:cas_user) )
      User.new( session[:cas_user ], session[:cas_user ], session[:cas_pgt])
    else
      nil
    end
  end

  helper_method :current_user



end
