class SearchController < ApplicationController
  def index
    @from_city = City.find(params[:city][:id])
    @from_hood = Hood.find(params[:hood][:id])
    @to_city = City.find(params[:city2][:id])
  end
end
