class HoodsController < ApplicationController
  
  def show
    @city = City.find(params[:city_id])
    @hood = Hood.find(params[:id])
    @match_mission = Hood.find(51)
    @match_soma = Hood.find(52)
    @match_castro = Hood.find(60)
    @matches = [@match_mission, @match_soma, @match_castro]
    @sf_hoods = City.find(2).hoods
  end

end
