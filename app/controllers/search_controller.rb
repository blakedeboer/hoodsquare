class SearchController < ApplicationController
  def index
    @sfrom_city = City.find(params[:city][:id])
    @from_hood = Hood.find(params[:hood][:id])
    @to_city = City.find(params[:city][:id])
  end
end
