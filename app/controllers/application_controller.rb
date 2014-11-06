class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter CASClient::Frameworks::Rails::Filter


  #before_filter :authenticate!

  def authenticate!
    CASClient::Frameworks::Rails::Filter.client.proxy_callback_url =
      "https://data-test.cc.nd.edu:8443/cas_proxy_callback/receive_pgt"
    CASClient::Frameworks::Rails::Filter.filter(self)

    if session[:cas_pgt]
      logger.debug ":cas_pgt: " + session[:cas_pgt].to_s
    end
  end


  def current_user
    @current_user ||= cas_user
  end

  def cas_user
    if ( session.has_key?(:cas_user) )
      User.new( session[:cas_user ] )
    else
      nil
    end
  end

  helper_method :current_user



end
