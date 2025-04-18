# frozen_string_literal: true

# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)

# rubocop:disable Packaging/BundlerSetupInTests
require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
# rubocop:enable Packaging/BundlerSetupInTests

$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)
