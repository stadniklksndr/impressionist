# frozen_string_literal: true

module Impressionist
  # nodoc
  module Impressionable
    extend ActiveSupport::Concern

    # nodoc
    module ClassMethods
      attr_accessor :impressionist_cache_options

      DEFAULT_CACHE = {
        counter_cache: false,
        column_name: :impressions_count,
        unique: :all
      }.freeze

      def impressionist_counter_cache_options
        @impressionist_cache_options ||= {}
        @impressionist_cache_options.reverse_merge!(DEFAULT_CACHE)
      end

      # asks impressionable entity whether or not it is counter_caching
      def impressionist_counter_caching?
        impressionist_counter_cache_options[:counter_cache]
      end

      def counter_caching?
        ::ActiveSupport::Deprecation
          .new("2.0.0", "impressionist")
          .warn("#counter_caching? is deprecated; please use #impressionist_counter_caching? instead")

        impressionist_counter_caching?
      end
    end

    def impressionist_count(options = {})
      # Uses these options as defaults unless overridden in options hash
      options.reverse_merge!(filter: :request_hash, start_date: nil, end_date: nil)

      # If a start_date is provided, finds impressions between then and the end_date. Otherwise returns all impressions
      imps = filter_impressions(options)

      # Count all distinct impressions unless the :all filter is provided.
      distinct = options[:filter] != :all
      if Rails::VERSION::MAJOR >= 4
        distinct ? imps.select(options[:filter]).distinct.count : imps.count
      else
        distinct ? imps.count(options[:filter], distinct: true) : imps.count
      end
    end

    def update_impressionist_counter_cache
      slave = Impressionist::UpdateCounters.new(self)
      slave.update
    end

    def impressionable?
      true
    end

    private

    def filter_impressions(options)
      imps =
        if options[:start_date].blank?
          impressions
        else
          start_date = Date.parse(options[:start_date])
          end_date = options[:end_date].present? ? Date.parse(options[:end_date]) : Time.zone.today

          impressions.where(created_at: start_date..end_date)
        end

      imps = imps.where(impressions: { message: options[:message] }) if options[:message]

      imps
    end
  end
end
