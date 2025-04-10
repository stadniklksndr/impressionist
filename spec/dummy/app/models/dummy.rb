# frozen_string_literal: true

# We don't really care about this model. It's just being used to test the uniqueness controller
# specs. Nevertheless, we need a model because the counter caching functionality expects it.
#
class Dummy < ApplicationRecord
  self.abstract_class = true # doesn't need to be backed by an actual table
  is_impressionable
end
