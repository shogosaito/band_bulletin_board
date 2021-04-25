module UsersHelper
  # 渡された年齢に本日なったばかりの生年月日をyyyymmdd形式で出力
  def calc_min_birthday(age)
    Date.today.strftime("%Y%m%d").to_i - age.to_i * 10000
  end

  # 渡された年齢であるギリギリの生年月日をyyyymmdd形式で出力
  def calc_max_birthday(age)
    Date.today.strftime("%Y%m%d").to_i - age.to_i * 10000 - 9999
  end

  # 渡された生年月日を年齢に変換して出力
  def calcAge(birthday_str)
    if birthday_str
      (Date.today.strftime("%Y%m%d").to_i - birthday_str.to_i) / 10000
    end
  end
end
