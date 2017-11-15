class SenatorsController < ApplicationController
  before_action :set_senator, only: [:show]
  
  def index
    @states = State.all
  end
  
  def show
  end
  
  private
  
  def set_senator
    @senator = Senator.find(params[:id])
  end
end
