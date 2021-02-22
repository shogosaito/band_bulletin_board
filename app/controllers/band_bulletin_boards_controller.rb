class BandBulletinBoardsController < ApplicationController
  def home
    @page = 5
    @microposts = Micropost.all.page(params[:page]).per(5)
  end

  def help
  end

  def about
  end

  def contact
  end
end
