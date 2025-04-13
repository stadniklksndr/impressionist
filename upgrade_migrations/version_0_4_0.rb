# frozen_string_literal: true

# Migration to add `referrer` column to impressions table
class Version04UpdateImpressionsTable < ActiveRecord::Migration[4.2]
  def self.up
    add_column :impressions, :referrer, :string
  end

  def self.down
    remove_column :impressions, :referrer
  end
end
