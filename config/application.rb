require_relative 'boot'

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.api_only = true # アプリはAPI専用となる

     config.middleware.use Rack::MethodOverride
     config.middleware.use ActionDispatch::Cookies
     config.middleware.use ActionDispatch::Session::CookieStore
     config.middleware.use ActionDispatch::Flash


    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.i18n.default_locale = :ja
  end
end
