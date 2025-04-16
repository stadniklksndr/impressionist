# frozen_string_literal: true

MongoMapper::Document.plugin Impressionist::Impressionable

module Impressionist
  # nodoc
  module Impressionable
    extend ActiveSupport::Concern

    # Class-level methods added when `Impressionable` is included.
    module ClassMethods
      # rubocop:disable Naming/PredicateName
      def is_impressionable(options = {})
        many(:impressions, as: :impressionable, dependent: :delete_all)
        @impressionist_cache_options = options
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end
