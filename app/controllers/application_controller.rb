class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authenticate
  helper_method :current_user
  protect_from_forgery with: :exception
  
  def authenticate
    exempt_paths = ['/login', '/dashboard', '/ajax_prescriptions.json','/sessions/create']
        
    if !(exempt_paths.include? request.path.to_s)
      if !logged_in?
        redirect_to login_url
      end  
    end
  end

  def print_and_redirect(print_url, redirect_url, message = "Printing label ...")
    #Function handles redirects when printing labels
    @print_url = print_url
    @redirect_url = redirect_url
    @message = message
    render :layout => false
  end
  
  def current_user
    @current_user ||= User.find_by_username(session[:user]) if session[:user]
  end

end
