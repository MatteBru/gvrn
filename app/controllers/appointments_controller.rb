class AppointmentsController < ApplicationController

  def create
    user = User.find(session[:user_id])
    time = Time.now
    redirect_to user_path(user)
  end

end
