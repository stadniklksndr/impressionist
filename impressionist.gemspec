# frozen_string_literal: true

require "impressionist/version"

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = "impressionist"
  s.version       = Impressionist::VERSION
  s.summary       = "Easy way to log impressions"
  s.description   = "Log impressions from controller actions or from a model"

  s.email         = "john.mcaliley@gmail.com"
  s.homepage      = "http://github.com/charlotte-ruby/impressionist"
  s.authors       = ["johnmcaliley"]

  s.license       = "MIT"

  s.files         = Dir["{app,lib}/**/*", "*.md"]
  s.require_path  = "lib"

  s.required_ruby_version = ">= 3.2.0"

  # Installed when someone installs gem
  s.add_dependency "friendly_id", ">= 5.5.0"
  s.add_dependency "rails", ">= 7"

  # ✅ MFA requirement
  s.metadata = { "rubygems_mfa_required" => "true" }
end
