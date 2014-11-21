class HoodsController < ApplicationController
  
  def show
    @city = City.find(params[:city_id])
    @hood = Hood.find(params[:id])
  end

end
