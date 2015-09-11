source 'https://rubygems.org'

ruby "2.2.1"
gem 'rails', '4.1.13'
gem 'pg'

gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0'
gem 'eventmachine', '~> 1.0.4'

gem 'bootstrap-sass'

gem 'haml'

gem 'devise-bootstrap-views'
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'

gem 'node'
gem 'twitter'
gem 'geocoder'
gem 'httparty'
gem 'honeybadger'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'spring'
  gem 'growl'
  gem 'brakeman'
  gem 'guard'
  gem 'guard-rspec'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rspec-rails', :git => 'https://github.com/rspec/rspec-rails.git'
  gem 'rspec', '~> 3.0.0.beta2'  # workaround from guard-rspec #236
  gem 'foreman'
  gem 'database_cleaner'
  gem "codeclimate-test-reporter"
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end
