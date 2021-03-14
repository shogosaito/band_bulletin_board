class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session
  include SessionsHelper
  include NotificationsHelper
  include UsersHelper
  before_action :set_search

  private

  def set_search
    @search = Micropost.ransack(params[:q])
  end

  def set_arrange
    if @part.start_with?(",")
      @part.slice!(0)
    end
    if @part.end_with?(",")
      @@part = @part.chop
    end
    if @genre.present?
      if @genre.start_with?(",")
        @genre.slice!(0)
      end
      if @genre.end_with?(",")
        @genre = @genre.chop
      end
    end
  end

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
