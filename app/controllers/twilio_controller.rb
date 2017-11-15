class TwilioController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :set_apt, only: [:connect]

  def set_apt
    @apt = Appointment.find(params[:apt_id])
  end
  helper_method :set_apt

  def connect
    # Our response to this request will be an XML document in the "TwiML"
    # format. Our Ruby library provides a helper for generating one
    # of these documents
    response = @apt.add_rep
    # Twilio::TwiML::VoiceResponse.new do |r|
    #   r.say('Thanks for contacting govern. Your '\
    #     'next available representative will take your call.', voice: 'alice')
    #   r.dial number: @apt.rep.phone

    render xml: response.to_xml
  end

end
