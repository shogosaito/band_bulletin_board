class InstaClonesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      if @feed_items.nil?
      @feed_items = []
    end
    end
    if @user.nil?
      @user  = current_user
    end
unless current_user.nil?
    @follow_users = []
    @follow_user = @user.following_ids
    @follow_users = User.find(@follow_user)
    end
  end
end
  def help
  end

  def about
  end

  def contact
  end
