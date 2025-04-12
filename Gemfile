# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "brakeman", ">= 7.0.0"
gem "bundler-audit", ">= 0.9.2"
gem "capybara", "~> 3.40.0"
gem "pry"
gem "rake", ">= 13.1.0"
gem "rdoc", ">= 6.3.4"
gem "rspec-rails", "~> 7.1.1"
gem "rubocop", "~> 1.75", require: false
gem "rubocop-capybara", "~> 2.22.1", require: false
gem "rubocop-rails", "~> 2.30.3", require: false
gem "rubocop-rake", "~> 0.7.1", require: false
gem "rubocop-rspec", "~> 3.5.0", require: false
gem "rubocop-rspec_rails", "~> 2.31.0", require: false
gem "simplecov"
gem "sqlite3", "~> 2.6.0"

platforms :jruby do
  gem "activerecord-jdbcsqlite3-adapter"
  gem "jdbc-sqlite3"
  gem "jruby-openssl"
end
