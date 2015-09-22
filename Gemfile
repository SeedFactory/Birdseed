source 'https://rubygems.org'

ruby '2.2.0'

gem 'unicorn'
gem 'rails', '4.2.3'
gem 'pg'
gem 'sass-rails', '~> 5.0'
  gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks', github: 'rails/turbolinks'

group :development, :test do
  gem 'web-console', '~> 2.0'
  gem 'byebug'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'letter_opener'
  gem 'dotenv-rails'
  gem 'quiet_assets'
  gem 'better_errors'
end

group :production do
  gem 'rails_12factor'
end

gem 'aws-sdk', '<2.0' # http://stackoverflow.com/a/28376678

gem 'deface', github: 'spree/deface' # https://github.com/bkeepers/dotenv/issues/177
gem 'spree', '3.0.3'
gem 'spree_gateway', github: 'spree/spree_gateway', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'

gem 'active_link_to'
gem 'rmagick'
