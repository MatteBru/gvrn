class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?
  helper_method :get_user_name

  def logged_in?
    !!session[:user_id]
  end

  def authenticate_user
    redirect_to login_path if !logged_in?
  end

  def get_user_name
    if logged_in?
      @user_name = User.find(session[:user_id]).first_name
    end
  end

end
