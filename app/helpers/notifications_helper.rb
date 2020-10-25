module NotificationsHelper
  def notification_form(notification)
    @comment=nil
    visitor=link_to notification.visitor.user_name, notification.visitor, style:"font-weight: bold;"
    your_post=link_to 'あなたの投稿', notification.micropost, style:"font-weight: bold;", remote: true
    case notification.action
    when "follow" then
      "#{visitor}があなたをフォローしました"
    when "like" then
      "#{visitor}が#{your_post}にいいね！しました"
    when "comment" then
      @comment=Comment.find_by(id:notification.comment_id)&.content
      "#{visitor}が#{your_post}にコメントしました"
    end
  end
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
