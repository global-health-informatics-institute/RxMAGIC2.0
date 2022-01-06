class ApplicationController < ActionController::Base
  include SessionsHelper
  # before_action :user_logged_in?, only: ["/login"]

  def user_logged_in?
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
  
end
