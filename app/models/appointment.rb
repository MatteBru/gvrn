class Appointment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :rep, dependent: :destroy

  include Twilier
  after_create :make_call, :remind, :confirm

  def make_call
    start_call
  end
  handle_asynchronously :make_call, :run_at => Proc.new { |i| i.when_to_call }

  def remind
    remind_message
  end
  handle_asynchronously :remind, :run_at => Proc.new { |i| i.when_to_remind }

  def confirm
    confirm_message
  end

  def when_to_remind
    time_before_appointment = 30.seconds
    self.time - time_before_appointment
  end


  def when_to_call
    # minutes_before_appointment = 30.minutes
    self.time
  end

end
