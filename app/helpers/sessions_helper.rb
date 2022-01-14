module SessionsHelper
  def login(user)
    session[:user] = user.username
    session[:user_role] = user.user_role
  end

  def logout
    session.delete(:user)
    session.delete(:user_role)
  end

  def current_user()
    if session[:user]
      @current_user ||= User.find_by_username(id: session[:user])
    end
  end

  def current_username
    return session[:user]
  end

  def logged_in?
    !session[:user_token].blank?
  end
end
