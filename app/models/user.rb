require "json"
require "http"
require "optparse"
class User < ApplicationRecord
  has_many :appointments
  has_secure_password
  before_save :dist_search

  CIV_HOST = 'https://www.googleapis.com/civicinfo/v2/representatives'
  GCODE_TOKEN = "AIzaSyAbq12TpjfMtq1d4nn95MbeutoEF6Hso5Y"

  def dist_search(addr)
    params = {
      address: addr,
      includeOffices: false,
      levels: "country"
    }

    url = "#{CIV_HOST}?key=#{GCODE_TOKEN}"

    response = HTTP.get(url, params: params)
    dist_hash = response.parse
    hash = dist_hash["divisions"].keys.select {|k|k.match(/state:(\w{2})\/cd:(\d+)/)}[0][/state:(\w{2})\/cd:(\d+)/, 0].split('/').map{|s|s.split(':')}.to_h
  end

end
