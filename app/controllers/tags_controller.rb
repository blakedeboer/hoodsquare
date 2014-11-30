class TagsController < ApplicationController
  
  def create
    @hood = Hood.find(tag_params[:tagger_id])
    @city = @hood.city
    Tag.create(tag_params)

    redirect_to root_path
  end

  private
    def tag_params
      params.require(:tag).permit(:tagger_id, :taggee_id)
    end
end