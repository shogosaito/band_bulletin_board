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

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
