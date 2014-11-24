class TagsController < ApplicationController
  
  def create
    @hood = Hood.find(tag_params[:tagger_id])
    @city = @hood.city
    if params[:commit] == "Agree" || params[:commit] == "Vote for this hood"
      Tag.create(tag_params)
    end

    redirect_to city_hood_path(@city, @hood)
  end

  private
    def tag_params
      params.require(:tag).permit(:tagger_id, :taggee_id)
    end
end