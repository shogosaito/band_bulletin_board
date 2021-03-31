Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
          scope: 'email calendar',
          display: 'popup'
  { provider_ignores_state: true }
end
