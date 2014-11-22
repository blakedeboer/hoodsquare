class CitiesController < ApplicationController
  
  def index
    @cities = City.all #for first city drop down list
    @hoods = Hood.all
  end

  # def create
  #   city_id = params([:city_id])
  #   hood_id = params([:id])

  #   if found?
  #     redirect_to city_hood_path(city_id, hood_id)
  #   else
  #     render: error
  #   end

  # end

  def show
    @city = City.find(params[:id])
  end
  
end
