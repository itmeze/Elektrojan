source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'therubyracer', :platforms => :ruby
gem 'carrierwave'
gem 'recaptcha', :require => "recaptcha/rails"
gem 'client_side_validations'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


group :development, :test do
  gem 'ruby-debug19'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
