source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'
gem 'rails', '6.0.0'
gem 'rails-i18n'
gem 'carrierwave'
gem 'counter_culture', '~> 1.8'
gem 'dotenv-rails'
gem 'omniauth-google-oauth2'
gem 'devise', git: "https://github.com/heartcombo/devise"
gem 'devise_token_auth'
gem 'rack-cors'
gem 'kaminari'
gem 'better_errors'
gem 'image_processing', '1.9.3'
gem 'mini_magick'
gem 'turbolinks', '5.2.0'
gem 'active_storage_validations', '0.8.2'
gem 'bcrypt',         '3.1.12'
gem 'faker',          '1.7.3'
gem 'will_paginate', '3.1.8'
gem 'bootstrap', '~> 4.1.3'
gem 'webpacker'
gem 'ransack'
gem 'sqlite3', '1.4.1', :group => [:development, :test]
gem 'pg', :group => :production
gem 'pry-rails'
gem 'bootstrap-social-rails'
gem 'seed-fu'
gem 'select2-rails'
gem 'autoprefixer-rails'
gem 'rubocop-airbnb'
gem 'jquery'
gem 'font-awesome-sass'
gem 'capybara', '3.28.0'
gem 'kaminari-bootstrap', '~> 3.0.1'

group :development, :test do
  gem 'byebug', '11.0.1', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'rspec-retry'
end

group :development do
  gem 'web-console',           '4.0.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem "letter_opener"
end

group :test do
  gem 'selenium-webdriver',       '3.142.4'
  gem 'webdrivers',               '4.1.2'
  gem 'rails-controller-testing', '1.0.4'
  gem 'guard',                    '2.16.2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
