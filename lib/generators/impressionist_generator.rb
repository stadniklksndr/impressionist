# frozen_string_literal: true

module Impressionist
  module Generators
    # Generator for setting up Impressionist configuration file.
    # Copies the initializer template to the Rails app.
    class ImpressionistGenerator < Rails::Generators::Base
      hook_for :orm, required: true, desc: "ORM to be invoked"

      source_root File.expand_path("templates", __dir__)

      def copy_config_file
        template "impression.rb.erb", "config/initializers/impression.rb"
      end
    end
  end
end
