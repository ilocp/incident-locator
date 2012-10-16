source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'annotate', ">=2.5.0"
  gem 'debugger'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'faker'
  gem 'spork'
  gem 'guard-rspec'
  gem 'guard-spork'
end

group :test do
    gem 'capybara'
    gem 'factory_girl_rails'
    # rake is required by travis ci
    gem 'rake'
end

group :production do
  gem 'pg'
  gem 'thin'
  gem 'newrelic_rpm'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'haml-rails'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 2.1.0.0'
gem 'gmaps4rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
