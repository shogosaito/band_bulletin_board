module ApplicationHelper
  include SessionsHelper
  include NotificationsHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "instaClone"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def logged_in?
    !current_user.nil?
  end

end
