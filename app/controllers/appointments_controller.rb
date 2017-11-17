class AppointmentsController < ApplicationController

  def create
    user = User.find(session[:user_id])
    time = Time.now
    flash[:message] = "Call Initiated"
    redirect_back(fallback_location: root_path)
  end

end
