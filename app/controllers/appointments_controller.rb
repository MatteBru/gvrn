class AppointmentsController < ApplicationController

  def time_helper
    y = appointment_params["date(1i)"].to_i
    mo = appointment_params["date(2i)"].to_i
    d = appointment_params["date(3i)"].to_i
    h = appointment_params["time(4i)"].to_i
    m = appointment_params["time(5i)"].to_i
    # byebug
    DateTime.new(y, mo, d, h, m) + 5.hours
  end

  def create
    # byebug
    appointment_params[:congressperson_type] == "representative" ? congressperson = Representative.find(appointment_params[:congressperson_id]) : congressperson = Senator.find(appointment_params[:congressperson_id])
    time = Time.now
    user = User.find(session[:user_id])
    # byebug

    if appointment_params[:delay]
      time = time_helper
      flash[:message] = "Call Scheduled for #{time_helper.in_time_zone("Eastern Time (US & Canada)").strftime("%A, %B %e at %l:%M %p")}"
    else
      flash[:message] = "Call Initiated"
    end
    
    Appointment.create(user: user, time: time, congressperson: congressperson)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    app = Appointment.find(params[:id])
    flash[:message] = "Your appointment with #{app.congressperson.full_name} on #{app.time.in_time_zone("Eastern Time (US & Canada)").strftime("%A, %B %e at %l:%M %p")} was succesfully deleted"
    app.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def appointment_params
    params.require(:appointment).permit(:congressperson_type, :congressperson_id, :delay, :"date(1i)", :"date(2i)", :"date(3i)", :"time(4i)", :"time(5i)")
  end

  # "date(2i)"=>"11",
  # "date(3i)"=>"17",
  # "time(1i)"=>"1",
  # "time(2i)"=>"1",
  # "time(3i)"=>"1",
  # "time(4i)"=>"20",
  # "time(5i)"=>"35")

end
