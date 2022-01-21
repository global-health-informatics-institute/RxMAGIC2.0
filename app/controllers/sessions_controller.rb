class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    # Action for user login into RxMAGIC
    user = User.authenticate(params["user"])
    if !user
      flash[:error] = "Wrong username or password."
      redirect_to "/login"
    else
      session[:user_token] = (0...5).map { (65 + rand(26)).chr }.join
      
      #logger.info "#{params[:user][:username]} logged in at #{Time.now}"
      user_role = User.find_by_username(params[:user][:username])
      if user_role.blank?
        session[:user] = params[:user][:username]
        redirect_to "/new_user_role"
      else
        login(user_role)
        redirect_to "/"
      end
    end
  end

  def destroy
    session[:user_token] = nil
    session[:user] = nil
    flash[:success] = {message: "Successfully logged out", title: "Logged Out"}
    redirect_to "/login" and return
  end

end

