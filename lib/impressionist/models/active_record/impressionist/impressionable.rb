# frozen_string_literal: true

module Impressionist
  module Impressionable
    # extends AS::Concern
    include Impressionist::IsImpressionable
  end
end

ActiveSupport.on_load(:active_record) { include Impressionist::Impressionable }
