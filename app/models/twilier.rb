module Twilier

  ACCOUNT_SID = ENV['twilio_sid'] # Your Account SID from www.twilio.com/console
  AUTH_TOKEN = ENV['twilio_auth']   # Your Auth Token from www.twilio.com/console
  TWILIO_NUMBER = ENV['twilio_number']  #Your Twilio Phone Number
  BASE_URL = ENV['base_url']  #Your App's Base URL


  def confirm_message
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    message = @client.messages.create(
        body: "Hello from GVRN, your appointment with #{self.congressperson.first_name} #{self.congressperson.last_name} is confirmed for #{self.time.in_time_zone("Eastern Time (US & Canada)").strftime("%A, %B %e at %l:%M %p")}.",
        to: self.user.phone,
        from: TWILIO_NUMBER) 

    puts message.sid
  end

  def remind_message
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    message = @client.messages.create(
        body: "Hello from GVRN, your appointment with #{self.congressperson.first_name} #{self.congressperson.last_name} is in 30 seconds",
        to: self.user.phone,
        from: TWILIO_NUMBER)
    puts message.sid
  end

  def start_call
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    call = @client.calls.create(
        url: "#{BASE_URL}/connect/#{self.id}",
        to: self.user.phone,
        from: TWILIO_NUMBER)
  end

  def add_rep
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Thanks for contacting govern. your'\
        "representative #{self.congressperson.first_name} #{self.congressperson.last_name}'s office will take your call.", voice: 'alice')
      r.dial number: self.congressperson.phone
    end
  end

end
