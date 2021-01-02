module NotificationsHelper
  def notification_form(notification)
    @comment = nil
    visitor = link_to notification.visitor.user_name, notification.visitor, style: "font-weight: bold;"
    your_post = link_to 'あなたの投稿', notification.micropost, style: "font-weight: bold;", remote: true
    unless visitor == current_user.user_name
    case notification.action
    when "like"
      "#{visitor}が#{your_post}にいいね！しました"
    when "comment" then
      @comment = Comment.find_by(id: notification.comment_id)&.content
      "#{visitor}が#{your_post}にコメントしました"
    end
    end
    binding.pry
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
