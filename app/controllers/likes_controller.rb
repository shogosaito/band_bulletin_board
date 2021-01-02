class LikesController < ApplicationController
  before_action :set_variables
  # def index
  #   @like_microposts = current_user.like_microposts
  # end
  
  def create
    like = current_user.likes.new(micropost_id: @micropost.id)
    like.save
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.reload
    @micropost.create_notification_like!(current_user)
  end

  def destroy
    like = current_user.likes.find_by(micropost_id: @micropost.id)
    like.destroy
    @micropost.reload
  end

  private

  def set_like
    @micropost = Micropost.find(params[:micropost_id])
  end

  def set_variables
    @micropost = Micropost.find(params[:micropost_id])
    @id_name = "#like-link-#{@micropost.id}"
  end
end
