# frozen_string_literal: true

require "rails/generators/active_record"

module ActiveRecord
  module Generators
    # Creating the migration file for the impressions table.
    class ImpressionistGenerator < Rails::Generators::Base
      include ::ActiveRecord::Generators::Migration

      source_root File.join(File.dirname(__FILE__), "templates")

      def create_migration_file
        migration_template "create_impressions_table.rb.erb", "db/migrate/create_impressions_table.rb"
      end
    end
  end
end
