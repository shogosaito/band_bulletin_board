class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def failure
    redirect_to root_path
  end

  def facebook
    callback_from :facebook
  end

  def twitter
    callback_from :twitter
  end

  def google
    callback_from :google
  end

  def line
    callback_from :line
  end

  def callback_from(provider)
    provider = provider.to_s

    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
