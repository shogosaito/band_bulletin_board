class NotificationsController < ApplicationController
  def index
    if current_user.passive_notifications.present?
      @notifications = current_user.passive_notifications.page(params[:page])
    end
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
