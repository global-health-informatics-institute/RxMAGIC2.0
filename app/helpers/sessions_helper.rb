module SessionsHelper
  def login(user)
    user_rec = User.find_by_username(user)
    session[:username] = user_rec.username
    session[:user_role] = user_rec.user_role
  end

  def logout
    session.delete(:username)
    session.delete(:user_role)
  end

  def current_user()
    if session[:username]
      @current_user ||= User.find_by_username(id: session[:username])
    end
  end

  def logged_in?
    !current_user.blank?
  end
end
