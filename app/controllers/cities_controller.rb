class CitiesController < ApplicationController
  
  def index
    @cities = City.all
    @city = City.new
  end

  def new
    @city = City.new
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

  # def index
  #   @city = City.find(params)
  #   @hood = @city.neighborhoods
  # end
  
end
