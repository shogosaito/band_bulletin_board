class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # callback for failure
  def failure
    flash[:danger] = "SNSログインに失敗しました。"
    redirect_to root_path
  end

  # callback for google
  def google_oauth2
    callback_from :google
  end

  # common callback method
  def callback_from(provider)
    provider = provider.to_s
    sns_info = User.from_omniauth(request.env['omniauth.auth'])
    @user = User.where(user_name: sns_info[:user][:user_name]).or(User.where(email: sns_info[:user][:email])).first || sns_info[:user]
    if @user.persisted?
      log_in @user
      flash[:success] = "#{provider}アカウントによる認証に成功しました。"
      redirect_to root_path
    else
      # 登録するviewのformに取得した値を初期値として入力するため、sessionを利用する
      session[:provider] = @user.provider
      session[:uid] = @user.uid
      session[:user_name] = @user.user_name
      session[:email] = @user.email
      session[:gender] = @user.gender
      session[:password] = @user.password
      session[:password_confirmation] = @user.password
      session["devise.#{provider}_data"] = request.env['omniauth.auth'].except("extra")
      # 登録フォームのviewにリダイレクトさせる
      redirect_to signup_path
    end
  end
end
