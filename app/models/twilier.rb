module Twilier
  # require 'twilio-ruby'


  ACCOUNT_SID = "ACd0c6a3b407a9e2259ef612a46c38d005" # Your Account SID from www.twilio.com/console
  AUTH_TOKEN = "4d081ee4f9e900b2d98db3f1a1fd309d"   # Your Auth Token from www.twilio.com/console
  TWILIO_NUMBER = "+15623624876"
  NGROK_URL = "https://gvrn-pr-3.herokuapp.com"


  def confirm_message
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    message = @client.messages.create(
        body: "Hello from GVRN, your appointment with #{self.congressperson.first_name} #{self.congressperson.last_name} is confirmed for #{self.time.in_time_zone("Eastern Time (US & Canada)").strftime("%A, %B %e at %l:%M %p")}.",
        to: self.user.phone,    # Replace with your phone number
        from: TWILIO_NUMBER)  # Replace with your Twilio number

    puts message.sid
  end

  def remind_message
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    message = @client.messages.create(
        body: "Hello from GVRN, your appointment with #{self.congressperson.first_name} #{self.congressperson.last_name} is in 30 seconds",
        to: self.user.phone,    # Replace with your phone number
        from: TWILIO_NUMBER)  # Replace with your Twilio number

    puts message.sid
  end

  def start_call
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    call = @client.calls.create(
        url: "#{NGROK_URL}/connect/#{self.id}",
        to: self.user.phone,    # Replace with your phone number
        from: TWILIO_NUMBER)  # Replace with your Twilio number
  end

  def add_rep
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Thanks for contacting govern. your'\
        "representative #{self.congressperson.first_name} #{self.congressperson.last_name}'s office will take your call.", voice: 'alice')
      r.dial number: self.congressperson.phone
    end
  end


  # def test_message
  #
  #   @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
  #   message = @client.messages.create(
  #       body: "Hello from GVRN",
  #       to: "+12032955525",    # Replace with your phone number
  #       from: TWILIO_NUMBER)  # Replace with your Twilio number
  #
  #   puts message.sid
  # end
  #
  # def test_call
  #   @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
  #   call = @client.calls.create(
  #       url: "http://b7a343c4.ngrok.io/connect",
  #       to: "+12032955525",    # Replace with your phone number
  #       from: TWILIO_NUMBER)  # Replace with your Twilio number
  #
  # end
end
