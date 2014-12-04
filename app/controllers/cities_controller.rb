class CitiesController < ApplicationController
  
  def index
    @cities = City.all
    @city = City.new
  end

  def new
    @city = City.new
  end

  def show
    @city = City.find(params[:id])
  end
  
end
