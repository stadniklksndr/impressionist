# frozen_string_literal: true

class CreateImpressionsTable < ActiveRecord::Migration[6.0]
  def self.up
    create_impressions_table
    add_indexes
  end

  def self.down
    drop_table :impressions
  end

  # rubocop:disable Metrics/MethodLength
  def self.create_impressions_table
    create_table :impressions, force: true do |t|
      t.string :impressionable_type
      t.integer :impressionable_id
      t.integer :user_id
      t.string :controller_name
      t.string :action_name
      t.string :view_name
      t.string :request_hash
      t.string :ip_address
      t.string :session_hash
      t.text :message
      t.text :referrer
      t.text :params
      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.add_indexes
    add_impressionable_indexes
    add_controller_action_indexes
    add_index :impressions, :user_id
  end

  def self.add_impressionable_indexes
    add_index :impressions, %i[impressionable_type message impressionable_id],
              name: "impressionable_type_message_index", unique: false, length: { message: 255 }

    add_index :impressions, %i[impressionable_type impressionable_id request_hash],
              name: "poly_request_index", unique: false

    add_index :impressions, %i[impressionable_type impressionable_id ip_address],
              name: "poly_ip_index", unique: false
    add_index :impressions, %i[impressionable_type impressionable_id session_hash],
              name: "poly_session_index", unique: false

    add_index :impressions, %i[impressionable_type impressionable_id params],
              name: "poly_params_request_index", unique: false, length: { params: 255 }
  end

  def self.add_controller_action_indexes
    add_index :impressions, %i[controller_name action_name request_hash],
              name: "controlleraction_request_index", unique: false

    add_index :impressions, %i[controller_name action_name ip_address],
              name: "controlleraction_ip_index", unique: false

    add_index :impressions, %i[controller_name action_name session_hash],
              name: "controlleraction_session_index", unique: false
  end
end
