class StaticController < ApplicationController

  def welcome
  end

  def search
    @user = User.new(address: params["address"], city: params["city"], address_state: params["address_state"], zip_code: params["zip_code"])
    @user.dist_search
  end
  
end
