# frozen_string_literal: true

class Widget < ApplicationRecord
  is_impressionable counter_cache: true, unique: :request_hash
end
