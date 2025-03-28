# frozen_string_literal: true

source "https://rubygems.org"

group :development, :test do
  gem "pry"
  gem "rake", ">= 13.1.0"
  gem "rdoc", ">= 6.3.4"
  gem "rubocop", "~> 1.74", require: false
  gem "rubocop-capybara", "~> 2.22.1", require: false
  gem "rubocop-rails", "~> 2.30.3", require: false
  gem "rubocop-rake", "~> 0.7.1", require: false
  gem "rubocop-rspec", "~> 3.5.0", require: false
  gem "rubocop-rspec_rails", "~> 2.31.0", require: false
  gem "sqlite3", "~> 2.6.0"
end

group :test do
  gem "capybara", "~> 3.40.0"
  gem "rspec-rails", "~> 7.1.1"
  gem 'simplecov'
end

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jdbc-sqlite3'
  gem 'jruby-openssl'
end

group :development do
  # Vulnerable versions of gems
  # bundle exec bundler-audit --update
  gem "bundler-audit", ">= 0.9.2"

  # Security vulnerability scanner
  # bundle exec brakeman -q -w2
  gem "brakeman", ">= 7.0.0"
end

# Loads dependencies from impressionist.gemspec
# When you run `bundle install` inside the root of the gem, this command:
#   * Reads the .gemspec file
#   * Installs all gems listed with `add_dependency` and `add_development_dependency`
#   * Ensures the gem’s dependencies are managed through Bundler
gemspec
