class HoodsController < ApplicationController
  
  def index
    @city = City.find(params[:city_id])
    render json: @city.hoods
  end

  def show
    @city = City.find(params[:city_id])
    @hood = Hood.find(params[:id])
  end

  def new
    @hood = Hood.new
    @cities = City.all
  end
end
