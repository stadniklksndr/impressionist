# frozen_string_literal: true

# Migration to add `params` column and index to impressions table
class Version152UpdateImpressionsTable < ActiveRecord::Migration[4.2]
  def self.up
    add_column :impressions, :params, :text

    add_index :impressions, %i[impressionable_type impressionable_id params],
              name: "poly_params_request_index", unique: false
  end

  def self.down
    remove_index :impressions, %i[impressionable_type impressionable_id params], name: "poly_params_request_index"
    remove_column :impressions, :params
  end
end
