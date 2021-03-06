# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "active_model_serializers", "~> 0.10.0"
gem "kaminari"
gem "pg", "~> 0.18"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.4"

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_girl_rails", "~> 4.0"
  gem "rspec-rails", "~> 3.7.0"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", "~> 0.51.0", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "simplecov", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
