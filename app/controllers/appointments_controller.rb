class AppointmentsController < ApplicationController

  def create
    byebug
    user = User.find(session[:user_id])
    time = Time.now
    flash[:message] = "Call Initiated"
    redirect_to user_path(user)
  end

end
