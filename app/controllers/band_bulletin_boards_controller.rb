class BandBulletinBoardsController < ApplicationController
  def home
    @page = 5
    @microposts = Micropost.includes(:user, user: :prefecture).all.page(params[:page]).
      includes(user: { user_image_attachment: :blob }).per(5)
  end

  def help
  end

  def about
  end

  def contact
  end
end
