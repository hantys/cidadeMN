source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'simple_form'
gem "devise", git: 'https://github.com/plataformatec/devise.git'
gem 'twitter-bootstrap-rails'
gem 'geocoder'
gem 'carrierwave'
gem "nested_form"
gem 'kaminari'
gem 'mini_magick'
gem 'jquery-rails'
gem 'rails', '~> 5.1.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'mina', '0.3.8'
gem 'mina-sidekiq', '0.4.1'
gem 'mina-puma', '0.3.2', require: false

gem 'coffee-rails', '~> 4.2'

gem 'jbuilder', '~> 2.5'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13.0'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
