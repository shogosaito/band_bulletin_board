class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session
  include SessionsHelper
  include NotificationsHelper
  before_action :set_search

  def set_search
    @search = Micropost.ransack(params[:q])
    @search_microposts = @search.result.page(params[:page])
  end

  private

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
