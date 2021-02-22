module UsersHelper
  def image_for(user)
    if user.image
      image_tag "/user_images/#{user.image}"
    else
      image_tag "wanko.png"
    end
  end

  # 渡された年齢に本日なったばかりの生年月日をyyyymmdd形式で出力
  def calc_min_birthday(age)
    Date.today.strftime("%Y%m%d").to_i - age.to_i * 10000
  end

  # 渡された年齢であるギリギリの生年月日をyyyymmdd形式で出力
  def calc_max_birthday(age)
    Date.today.strftime("%Y%m%d").to_i - age.to_i * 10000 - 9999
  end

  def calcAge(birthdayStr)
    if birthdayStr
      (Date.today.strftime("%Y%m%d").to_i - birthdayStr.to_i) / 10000
    end
  end
end
