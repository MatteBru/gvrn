class StaticController < ApplicationController

  def welcome
  end

  def search
    @user = User.new(address: params["address"], city: params["city"], address_state: params["address_state"], zip_code: params["zip_code"])
    @user.dist_search
    if !@user.errors.empty?
      flash.now[:error] = @user.errors[:address][0]
      render :welcome
    end
  end

end
