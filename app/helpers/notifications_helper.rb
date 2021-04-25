module NotificationsHelper
  def notification_form(notification)
    @comment = nil
    case notification.action
    when "like"
      tag.a(notification.visitor.user_name, href: notification.visitor) + "さんが" +
      tag.a('あなたの投稿', href: notification.micropost) + "をお気に入りに追加しました。"
    when "comment" then
      @comment = Comment.find_by(id: notification.comment_id)&.content
      tag.a(notification.visitor.user_name, href: notification.visitor) + "さんが" +
      tag.a('あなたの投稿', href: notification.micropost) + "にコメントしました。" + "コメント内容「 " + "#{@comment}" + "」"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
