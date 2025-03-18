# frozen_string_literal: true

require "spec_helper"

RSpec.describe Impressionist::RailsToggle do
  let(:toggle) { described_class.new }

  context "when using rails < 4" do
    it "is included" do
      stub_const("::Rails::VERSION::MAJOR", 3)
      expect(toggle).to be_should_include
    end

    it "is not included when strong parameters is defined" do
      stub_const("::Rails::VERSION::MAJOR", 3)
      stub_const("StrongParameters", Module.new)

      expect(toggle).not_to be_should_include
    end
  end

  context "when using rails >= 4" do
    it "is not included" do
      stub_const("::Rails::VERSION::MAJOR", 4)

      expect(toggle).not_to be_should_include
    end
  end
end
