source 'https://rubygems.org'

if ENV['RAILS_ENV'] == 'production'
  ruby '2.2.2'
end

gem 'rails', '4.2.3'
gem 'rails-api'
gem 'pg'
gem 'puma'
gem 'mini_magick'
gem 'rails_stdout_logging', group: :production
gem 'aws-sdk'

group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'vcr'
  gem 'webmock'
end
