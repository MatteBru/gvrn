class SessionsController < ApplicationController

  def create
    @user = User.find_by(email: login_params[:email])
    session[:user_id] = @user.id if @user && @user.authenticate(login_params[:password])     
    redirect_to user_path(@user)
  end

  def destroy
    session[:user_id] = nil 
    redirect_back(fallback_location: root_path)
  end

  private

  def login_params
    params.require(:session).permit(:email, :password)
  end
end
