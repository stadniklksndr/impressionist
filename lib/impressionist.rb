# frozen_string_literal: true

require "impressionist/load"

# Main entry point for the Impressionist gem.
module Impressionist
  # Define default ORM using Rails' module-level accessor
  mattr_accessor :orm
  self.orm = :active_record

  # Load configuration from initializer
  def self.setup
    yield self
  end
end
