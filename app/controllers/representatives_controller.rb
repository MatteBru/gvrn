class RepresentativesController < ApplicationController
  before_action :set_representative, only: [:show]
  helper_method :parse_dw_score
  
  def index
    @states = State.all
  end
  
  def show
  end
  
  private
  
  def set_representative
    @representative = Representative.find(params[:id])
  end

  def parse_dw_score
    case @representative.dw_nominate
    when -1.0...-0.5
      "solid liberal"
    when -0.5...-0.3
      "liberal"
    when -0.3...-0.1
      "moderate liberal"
    when -0.1...0.1
      "centrist"
    when 0.1...0.3
      "moderate conservative"
    when 0.3...0.5
      "conservative"
    when 0.5..1.0
      "solid conservative"
    else
      "N/A"
    end
  end
end
