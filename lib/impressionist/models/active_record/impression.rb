# frozen_string_literal: true

# nodoc
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

# Responsability
# * logs an error if imps_id and imps_type can not be found
# * asks updatable? whether it may or may not be updated
# class Impression < ActiveRecord::Base
class Impression < ApplicationRecord
  include Impressionist::CounterCache

  # sets belongs_to and attr_accessible depending on Rails version
  Impressionist::SetupAssociation.new(self).set

  store :params
  after_save :impressionable_counter_cache_updatable?
end
