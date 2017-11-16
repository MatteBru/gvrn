require "json"
require "http"
require "optparse"
class User < ApplicationRecord
  has_many :appointments
  belongs_to :district
  has_one :representative, through: :district
  has_one :state, through: :district
  has_many :senators, through: :state
  has_secure_password

  before_validation :dist_search

  validates_presence_of :email



  CIV_HOST = 'https://www.googleapis.com/civicinfo/v2/representatives'
  GCODE_TOKEN = "AIzaSyAbq12TpjfMtq1d4nn95MbeutoEF6Hso5Y"

  def addr_string
    "#{self.address}, #{self.city}, #{self.address_state} #{self.zip_code}"
  end

  def dist_search
    # byebug
    params = {
      address: self.addr_string,
      includeOffices: false,
      levels: "country"
    }
    url = "#{CIV_HOST}?key=#{GCODE_TOKEN}"

    byebug

    response = HTTP.get(url, params: params)
    gci_api_hash = response.parse


    norm_addr_hash = gci_api_hash["normalizedInput"]

    begin
      cong_dist_hash = gci_api_hash["divisions"].keys.select{|k|k.match(/state:(\w{2})\/cd:(\d+)/)}[0][/state:(\w{2})\/cd:(\d+)/, 0].split('/').map{|s|s.split(':')}.to_h
      cd = cong_dist_hash["cd"]
      # byebug
      state = State.find_by(abbreviation: cong_dist_hash["state"].upcase)
    rescue
      state = State.find_by(abbreviation: norm_addr_hash["state"])
      cd = "At-Large"
    end

    self.district = District.find_by(state: state, name: cd)

    # NORMALIZE AND SET ADDRESS ATTRIBUTES
    self.address = norm_addr_hash["line1"]
    self.city = norm_addr_hash["city"]
    self.address_state = norm_addr_hash["state"]
    self.zip_code = norm_addr_hash["zip"]
  end

  def map_id
    st = self.state.id
    d = self.district.name == "At-Large" ? "0" : self.district.name
    st += 1 if st >= 3
    st += 1 if st >= 7
    st += 1 if st >= 14
    st += 1 if st >= 43
    st += 1 if st >= 52
    "#{st.to_s.rjust(2, '0')}#{d.rjust(2, '0')}"
  end

  def verification_code=(code)
    @code = code
  end

  def verify?(entered)
    @code == entered
  end



end
