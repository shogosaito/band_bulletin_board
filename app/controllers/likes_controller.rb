class LikesController < ApplicationController
  before_action :set_variables
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
  
  #お気に入りが紐づく投稿を事前に取得
  def set_variables
    @micropost = Micropost.find(params[:micropost_id])
    @id_name = "#like-link-#{@micropost.id}"
  end
end
