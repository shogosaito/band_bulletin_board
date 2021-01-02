class InstaClonesController < ApplicationController
  def home
    @microposts = Micropost.all
  end
  def help
  end

  def about
  end

  def contact
  end
end
