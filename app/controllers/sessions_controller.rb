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
      login(user)
      redirect_to "/"
    end
  end

  def destroy
    logout
    flash[:success] = "Successfully logged out"
    redirect_to root_url
  end

end

