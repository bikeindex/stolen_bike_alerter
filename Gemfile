# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.5.5"

gem "bootstrap-sass"
gem "coffee-rails"
gem "devise"
gem "devise-bootstrap-views"
gem "geocoder", "~> 1.2.1"
gem "haml"
gem "honeybadger"
gem "httparty"
gem "jquery-rails"
gem "omniauth", "~> 1.2.2"
gem "omniauth-twitter", "~> 1.2.0"
gem "pg", "~> 0.20.0"
gem "puma", "~> 3.8.2"
gem "rails", "4.2.10"
gem "sass-rails"
gem "twitter", "~> 5.9.0"
gem "uglifier"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "codeclimate-test-reporter"
  gem "database_cleaner"
  gem "dotenv-rails"
  gem "foreman"
  gem "rspec", "~> 3.7.0" # workaround from guard-rspec #236
  gem "rspec-rails", "~> 3.7.2"
  gem "pry-rails"
end

group :test do
  gem "factory_girl_rails"
  gem "shoulda-matchers"
  gem "vcr"
  gem "webmock"
end
