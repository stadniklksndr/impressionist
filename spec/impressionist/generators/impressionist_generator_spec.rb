# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/impressionist_generator"

RSpec.describe Impressionist::Generators::ImpressionistGenerator do
  describe "list generators in the app" do
    # __dir__: gives you the directory of the current file where the test is running
    # moves up from where the current test is located and then navigates into the dummy directory
    let(:dummy_path) { File.expand_path("../../dummy", __dir__) }

    let(:output) do
      Dir.chdir(dummy_path) do
        output = `rails generate | grep impressionist`
        output.split("\n").join
      end
    end

    it "checks if all impressionist generators are included in the output" do
      expect(output).to include(
        "impressionist:impressionist", "active_record:impressionist",
        "mongo_mapper:impressionist", "mongoid:impressionist"
      )
    end
  end

  describe "class methods" do
    context "with hook_for" do
      it "ORM to be invoked" do
        expect(described_class).to respond_to(:orm_generator)
      end
    end

    it "has source root" do
      expect(described_class.source_root).to include("/generators/templates")
    end
  end

  describe "list of commands that will be executed" do
    it "includes _invoke_from_option_orm command" do
      expect(described_class.commands["_invoke_from_option_orm"]).to be_present
    end

    it "includes copy_config_file command" do
      expect(described_class.commands["copy_config_file"]).to be_present
    end
  end

  describe "#copy_config_file" do
    let(:instance) { described_class.new }

    it "adds impression config file" do
      allow(instance).to receive(:template)
      described_class.commands["copy_config_file"].run(instance)

      expect(instance).to have_received(:template).with(
        "impression.rb.erb", "config/initializers/impression.rb"
      )
    end
  end
end
