module UsersHelper
  def image_for(user)
    if user.image
      image_tag "/user_images/#{user.image}"
    else
      image_tag "wanko.png"
    end
  end
end
