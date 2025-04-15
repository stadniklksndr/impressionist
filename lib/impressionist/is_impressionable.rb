# frozen_string_literal: true

module Impressionist
  # nodoc
  module IsImpressionable
    extend ActiveSupport::Concern

    # Class-level methods added when `IsImpressionable` is included.
    module ClassMethods
      # rubocop:disable Naming/PredicateName
      def is_impressionable(options = {})
        define_association
        @impressionist_cache_options = options

        true
      end
      # rubocop:enable Naming/PredicateName

      private

      def define_association
        has_many(:impressions, as: :impressionable, dependent: :delete_all)
      end
    end
  end
end
