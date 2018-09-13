source 'https://rubygems.org'
ruby '2.5.1'

gem 'rails', '4.2.10'
gem 'pg', '~> 0.20.0'

gem 'puma', '~> 3.8.2'

gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'eventmachine', '~> 1.0.4'

gem 'bootstrap-sass'

gem 'haml'

gem 'devise-bootstrap-views'
gem 'devise'
gem 'omniauth', '~> 1.2.2'
gem 'omniauth-twitter', '~> 1.2.0'

# gem 'node' < Gem no longer exists, not sure why we needed it
gem 'twitter', '~> 5.9.0'
gem 'geocoder', '~> 1.2.1'
gem 'httparty'
gem 'honeybadger'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'dotenv-rails'
  # gem 'rb-fsevent', '~> 0.9.1' # Dependency hell
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rspec', '~> 3.7.0'  # workaround from guard-rspec #236
  gem 'foreman'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end
