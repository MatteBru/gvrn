class SessionsController < ApplicationController

  def create

    @user = User.find_by(email: login_params[:email])
    # byebug
    if @user && @user.authenticate(login_params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash.now[:error] = 'Sorry, no user was found with that email/password'
      render :login
    end
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
