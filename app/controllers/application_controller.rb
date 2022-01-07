class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :user_logged_in?, :only => ['/login', '/dashboard', '/ajax_prescriptions']
  helper_method :current_user
  #before_action :user_logged_in?, only: ["/login"]
  protect_from_forgery with: :exception
  

  def user_logged_in?
    puts("checking login")
    if !logged_in?
      redirect_to login_url
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
