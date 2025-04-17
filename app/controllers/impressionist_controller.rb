# frozen_string_literal: true

require "digest/sha2"

module ImpressionistController
  # nodoc
  module ClassMethods
    def impressionist(opts = {})
      if Rails::VERSION::MAJOR >= 5
        before_action { |c| c.impressionist_subapp_filter(opts) }
      else
        before_filter { |c| c.impressionist_subapp_filter(opts) }
      end
    end
  end

  # rubocop:disable Metrics/ModuleLength
  # nodoc
  module InstanceMethods
    def self.included(base)
      if Rails::VERSION::MAJOR >= 5
        base.before_action :impressionist_app_filter
      else
        base.before_filter :impressionist_app_filter
      end
    end

    def impressionist(obj, message = nil, opts = {})
      return unless should_count_impression?(opts)
      raise "#{obj.class} is not impressionable!" unless obj.respond_to?(:impressionable?)
      return unless unique_instance?(obj, opts[:unique])

      obj.impressions.create(associative_create_statement({ message: message }))
    end

    def impressionist_app_filter
      @impressionist_hash = Digest::SHA2.hexdigest(Time.now.to_f.to_s + rand(10_000).to_s)
    end

    def impressionist_subapp_filter(opts = {})
      return unless should_count_impression?(opts)

      actions = opts[:actions]
      actions.collect!(&:to_s) if actions.present?
      return unless (actions.blank? || actions.include?(action_name)) && unique?(opts[:unique])

      Impression.create(direct_create_statement)
    end

    protected

    # creates a statment hash that contains default values for creating an impression via an AR relation.
    def associative_create_statement(query_params = {})
      query_params.reverse_merge!(
        user_id: user_id,
        action_name: action_name,
        referrer: request.referer,
        session_hash: session_hash,
        ip_address: request.remote_ip,
        controller_name: controller_name,
        request_hash: @impressionist_hash,
        params: parameter_filter.filter(params_hash)
      )
    end

    private

    def parameter_filter
      # support older versions of rails:
      # see https://github.com/rails/rails/pull/34039
      filter_params = Rails.application.config.filter_parameters
      if Rails::VERSION::MAJOR < 6
        ActionDispatch::Http::ParameterFilter.new(filter_params)
      else
        ActiveSupport::ParameterFilter.new(filter_params)
      end
    end

    def bypass
      Impressionist::Bots.bot?(request.user_agent)
    end

    def should_count_impression?(opts)
      !bypass && condition_true?(opts[:if]) && condition_false?(opts[:unless])
    end

    def condition_true?(condition)
      condition.present? ? conditional?(condition) : true
    end

    def condition_false?(condition)
      condition.present? ? !conditional?(condition) : true
    end

    def conditional?(condition)
      condition.is_a?(Symbol) ? send(condition) : condition.call
    end

    def unique_instance?(impressionable, unique_opts)
      unique_opts.blank? || !impressionable.impressions.where(unique_query(unique_opts, impressionable)).exists?
    end

    def unique?(unique_opts)
      unique_opts.blank? || check_impression?(unique_opts)
    end

    def check_impression?(unique_opts)
      impressions = Impression.where(unique_query(unique_opts - [:params]))
      check_unique_impression?(impressions, unique_opts)
    end

    def check_unique_impression?(impressions, unique_opts)
      impressions_present = impressions.exists?

      if impressions_present && unique_opts_has_params?(unique_opts)
        check_unique_with_params?(impressions)
      else
        !impressions_present
      end
    end

    def unique_opts_has_params?(unique_opts)
      unique_opts.include?(:params)
    end

    def check_unique_with_params?(impressions)
      request_param = params_hash
      impressions.detect { |impression| impression.params == request_param }.nil?
    end

    # creates the query to check for uniqueness
    def unique_query(unique_opts, impressionable = nil)
      full_statement = direct_create_statement({}, impressionable)
      # reduce the full statement to the params we need for the specified unique options
      unique_opts.index_with do |param|
        full_statement[param]
      end
    end

    # creates a statment hash that contains default values for creating an impression.
    def direct_create_statement(query_params = {}, impressionable = nil)
      query_params.reverse_merge!(
        impressionable_type: controller_name.singularize.camelize,
        impressionable_id: impressionable.present? ? impressionable.id : params[:id]
      )

      associative_create_statement(query_params)
    end

    def session_hash
      id = session.id || request.session_options[:id]

      if id.respond_to?(:cookie_value)
        id.cookie_value
      elsif id.is_a?(Rack::Session::SessionId)
        id.public_id
      else
        id.to_s
      end
    end

    def params_hash
      request.params.except(:controller, :action, :id)
    end

    # use both @current_user and current_user helper
    def user_id
      user_id = safe_user_id { @current_user&.id }
      user_id = safe_user_id { current_user&.id } if user_id.blank?
      user_id
    end

    def safe_user_id
      yield
    rescue StandardError
      nil
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
