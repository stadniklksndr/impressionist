# frozen_string_literal: true

# Migration to add `session_hash` column to impressions table
class CreateImpressionsTable < ActiveRecord::Migration[4.2]
  def self.up
    add_column :impressions, :session_hash, :string
    remove_index :impressions, name: :poly_index
    remove_index :impressions, name: :controlleraction_index

    add_index :impressions, %i[impressionable_type impressionable_id request_hash],
              name: "poly_request_index", unique: false

    add_index :impressions, %i[impressionable_type impressionable_id ip_address],
              name: "poly_ip_index", unique: false

    add_index :impressions, %i[impressionable_type impressionable_id session_hash],
              name: "poly_session_index", unique: false

    add_controller_action_indexes
  end

  def self.down
    remove_column :impressions, :session_hash
    remove_index :impressions, name: :poly_request_index
    remove_index :impressions, name: :poly_ip_index
    remove_index :impressions, name: :poly_session_index
    remove_index :impressions, name: :controlleraction_request_index
    remove_index :impressions, name: :controlleraction_ip_index
    remove_index :impressions, name: :controlleraction_session_index
    remove_index :impressions, :user_id
    down_return_indexes
  end

  def self.add_controller_action_indexes
    add_index :impressions, %i[controller_name action_name request_hash],
              name: "controlleraction_request_index", unique: false

    add_index :impressions, %i[controller_name action_name ip_address],
              name: "controlleraction_ip_index", unique: false

    add_index :impressions, %i[controller_name action_name session_hash],
              name: "controlleraction_session_index", unique: false
  end

  def self.down_return_indexes
    add_index :impressions, %i[impressionable_type impressionable_id request_hash ip_address],
              name: "poly_index", unique: false
    add_index :impressions, %i[controller_name action_name request_hash ip_address],
              name: "controlleraction_index", unique: false
  end
end
