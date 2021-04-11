class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]) if current_user.passive_notifications.present?
    if @notifications.present?
      @notifications.where(checked: false).each do |notification|
        notification.update_attributes(checked: true)
      end
    end
  end

  def destroy
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notification_path
  end

  def show
    render "notification/index"
  end
end
