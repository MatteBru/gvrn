require "json"
require "http"
require "optparse"
class User < ApplicationRecord
  has_many :appointments
  has_secure_password

  CIV_HOST = 'https://www.googleapis.com/civicinfo/v2/representatives'
  GCODE_TOKEN = "AIzaSyAbq12TpjfMtq1d4nn95MbeutoEF6Hso5Y"

  def addr_string
    "#{self.address} #{self.city} #{self.state} #{self.zip_code}"
  end

  def dist_search
    params = {
      address: self.addr_string,
      includeOffices: false,
      levels: "country"
    }

    url = "#{CIV_HOST}?key=#{GCODE_TOKEN}"

    response = HTTP.get(url, params: params)
    dist_hash = response.parse
    dist_hash["divisions"].keys.select {|k|k.match(/state:(\w{2})\/cd:(\d+)/)}[0][/state:(\w{2})\/cd:(\d+)/, 0].split('/').map{|s|s.split(':')}.to_h
  end

end
