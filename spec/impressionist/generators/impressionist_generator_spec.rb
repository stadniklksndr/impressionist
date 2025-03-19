# frozen_string_literal: true

require "spec_helper"
# require "rails/generators/test_case"
require "rails/generators"
require "generators/impressionist_generator"

RSpec.describe Impressionist::Generators::ImpressionistGenerator do
  # __dir__: gives you the directory of the current file where the test is running
  # moves up from where the current test is located and then navigates into the dummy directory
  let(:dummy_path) { File.expand_path("../../dummy", __dir__) }

  describe "list generators in the app" do
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

  describe "hook_for" do
    it "ORM to be invoked" do
      expect(described_class).to respond_to(:orm_generator)
    end
  end
end
