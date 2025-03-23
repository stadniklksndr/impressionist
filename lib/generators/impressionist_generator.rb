# frozen_string_literal: true

module Impressionist
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      # create command `_invoke_from_option_orm` in thor `invoke_from_option`
      # where rails `prepare_for_invocation` find ActiveRecord::Generators::ImpressionistGenerator and call it
      # using `find_by_namespace` and default value orm: :active_record
      # that was added in ActiveRecord::Railtie and configure! in Rails::Generators
      # Rails::Railtie configuration can access a config object which contains configuration shared by all railties
      hook_for :orm, required: true, desc: "ORM to be invoked"

      source_root File.expand_path('../templates', __FILE__)

      def copy_config_file
        template 'impression.rb.erb', 'config/initializers/impression.rb'
      end
    end
  end
end
