# frozen_string_literal: true

module Impressionist
  # Responsibility
  # Toggles between rails > 3.1 < 4
  # In order to make attr_accessible available in a rails app < 4
  class RailsToggle
    # decides where or not to include attr_accessible
    # rubocop:disable Style/Not
    def should_include?
      supported_by_rails? && (not using_strong_parameters?)
    end
    # rubocop:enable Style/Not

    private

    def using_strong_parameters?
      defined?(StrongParameters)
    end

    # returns false if rails >= 4
    # true if rails < 4
    def supported_by_rails?
      ::Rails::VERSION::MAJOR.to_i < 4
    end
  end
end
