# frozen_string_literal: true

require "rails/generators/active_record"

module ActiveRecord
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      # adds `next_migration_number`
      # from activerecord/lib/rails/generators/active_record/migration
      include ::ActiveRecord::Generators::Migration

      source_root File.join(File.dirname(__FILE__), 'templates')

      def create_migration_file
        migration_template 'create_impressions_table.rb.erb', 'db/migrate/create_impressions_table.rb'
      end
    end
  end
end
