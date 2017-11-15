require "json"
require "http"
require "optparse"
class User < ApplicationRecord
  has_many :appointments
  belongs_to :district
  has_secure_password
  before_validation :dist_search

  CIV_HOST = 'https://www.googleapis.com/civicinfo/v2/representatives'
  GCODE_TOKEN = "AIzaSyAbq12TpjfMtq1d4nn95MbeutoEF6Hso5Y"

  def addr_string
    "#{self.address}, #{self.city}, #{self.address_state} #{self.zip_code}"
  end

  def dist_search
    params = {
      address: self.addr_string,
      includeOffices: false,
      levels: "country"
    }
    url = "#{CIV_HOST}?key=#{GCODE_TOKEN}"

    response = HTTP.get(url, params: params)
    gci_api_hash = response.parse
    # byebug

    cong_dist_hash = gci_api_hash["divisions"].keys.select {|k|k.match(/state:(\w{2})\/cd:(\d+)/)}[0][/state:(\w{2})\/cd:(\d+)/, 0].split('/').map{|s|s.split(':')}.to_h
    norm_addr_hash = gci_api_hash["normalizedInput"]

    state = State.find_by(abbreviation: cong_dist_hash["state"].upcase)
    self.district = District.find_by(state: state, name: cong_dist_hash["cd"])
    # NORMALIZE AND SET ADDRESS ATTRIBUTES
    self.address = norm_addr_hash["line1"]
    self.city = norm_addr_hash["city"]
    self.address_state = norm_addr_hash["state"]
    self.zip_code = norm_addr_hash["zip"]
  end

end
