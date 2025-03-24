# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/active_record/impressionist_generator"

RSpec.describe ActiveRecord::Generators::ImpressionistGenerator do
  describe ".next_migration_number" do
    it "includes ActiveRecord::Generators::Migration" do
      expect(described_class.ancestors).to include(ActiveRecord::Generators::Migration)
    end

    it "includes Rails::Generators::Migration" do
      expect(described_class.ancestors).to include(Rails::Generators::Migration)
    end

    it "includes method" do
      expect(described_class).to respond_to(:next_migration_number)
    end
  end

  describe "class methods" do
    it "has source root" do
      expect(described_class.source_root).to include("/generators/active_record/templates")
    end
  end

  describe "list of commands that will be executed" do
    it "includes create_migration_file command" do
      expect(described_class.commands["create_migration_file"]).to be_present
    end
  end

  describe "#create_migration_file" do
    let(:instance) { described_class.new }

    it "adds migration template" do
      allow(instance).to receive(:migration_template)
      described_class.commands["create_migration_file"].run(instance)

      expect(instance).to have_received(:migration_template).with(
        "create_impressions_table.rb.erb", "db/migrate/create_impressions_table.rb"
      )
    end
  end
end
