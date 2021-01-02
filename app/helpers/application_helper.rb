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

  def reset_tag(value = "Reset form", options = {})
    options = options.stringify_keys
    tag :input, { type: "reset", value: value }.update(options)
  end
end
