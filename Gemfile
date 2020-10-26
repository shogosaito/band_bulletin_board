source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'
gem 'rails',                   '6.0.0'
gem 'rails-i18n'
gem 'carrierwave'
gem 'counter_culture', '~> 1.8'
gem 'dotenv-rails'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-line'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'devise'
gem 'devise_token_auth'
gem 'rack-cors'
gem 'kaminari'
gem 'better_errors'
gem 'image_processing',           '1.9.3'
gem 'mini_magick'
gem 'bootstrap-sass', '3.4.1'
gem 'turbolinks', '5.2.0'
gem 'active_storage_validations', '0.8.2'
gem 'bcrypt',         '3.1.12'
gem 'faker',          '1.7.3'
gem 'will_paginate',           '3.1.8'
gem 'bootstrap', '~> 4.1.3'
gem 'jquery-rails'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'bootsnap',   '1.4.5', require: false
gem 'webpacker'
gem 'ransack'
gem 'sqlite3',    '1.4.1', :group => [:development, :test]
gem 'pg', :group => :production

group :development, :test do
  # gem 'sqlite3', '1.4.1'
  gem 'byebug',  '11.0.1', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console',           '4.0.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem "letter_opener"
end

group :test do
  gem 'capybara',                 '3.28.0'
  gem 'selenium-webdriver',       '3.142.4'
  gem 'webdrivers',               '4.1.2'
  gem 'rails-controller-testing', '1.0.4'
  gem 'minitest',                 '5.11.3'
  gem 'minitest-reporters',       '1.3.8'
  gem 'guard',                    '2.16.2'
  gem 'guard-minitest',           '2.4.6'
end


# Windows ではタイムゾーン情報用の tzinfo-data gem を含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
