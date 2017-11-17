class AppointmentsController < ApplicationController

  def create
    # byebug
    params[:congressperson_type] == "representative" ? congressperson = Representative.find(params[:congressperson_id]) : congressperson = Senator.find(params[:congressperson_id])
    time = Time.now
    user = User.find(session[:user_id])
    time = params[:time] if params[:delay]
    Appointment.create(user: user, time: time, congressperson: congressperson)
    redirect_to user_path(user)
  end

end
