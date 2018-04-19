class TwilioController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :set_apt, only: [:connect]
  before_action :authenticate_twilio_request, only: [:connect]

  AUTH_TOKEN = ENV['twilio_auth']

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

  def authenticate_twilio_request
    if twilio_req?
      return true
    else
      response = Twilio::TwiML::VoiceResponse.new do|r|
        r.hangup
      end

      render xml: response.to_s, status: :unauthorized
      false
    end
  end

private

def twilio_req?
  # Helper from twilio-ruby to validate requests.
  validator = Twilio::Security::RequestValidator.new(AUTH_TOKEN)

  # the POST variables attached to the request (eg "From", "To")
  # Twilio requests only accept lowercase letters. So scrub here:
  post_vars = params.reject { |k, _| k.downcase == k }
  twilio_signature = request.headers['HTTP_X_TWILIO_SIGNATURE']

  validator.validate(request.url, post_vars, twilio_signature)
end


end
