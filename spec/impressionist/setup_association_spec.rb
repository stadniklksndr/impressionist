# frozen_string_literal: false

require "spec_helper"

RSpec.describe Impressionist::SetupAssociation do
  let(:mock) { double }
  let(:setup_association) { described_class.new(mock) }

  it "includes when togglable" do
    allow(mock).to receive(:attr_accessible).and_return(true)
    allow(setup_association).to receive(:toggle).and_return(true)

    expect(setup_association).to be_include_attr_acc
  end

  it "is not included if it is not togglable" do
    allow(setup_association).to receive(:toggle).and_return(false)
    expect(setup_association).not_to be_include_attr_acc
  end

  context "when using rails >= 5" do
    before do
      stub_const("::Rails::VERSION::MAJOR", 5)
      allow(mock).to receive(:belongs_to).and_return(true)
    end

    it "calls belongs_to with correct arguments" do
      setup_association.define_belongs_to

      expect(mock).to have_received(:belongs_to).with(
        :impressionable, { polymorphic: true, optional: true }
      )
    end

    it "returns truthy when calling define_belongs_to" do
      expect(setup_association.define_belongs_to).to be_truthy
    end

    it "has set as falsy" do
      expect(setup_association.set).to be_falsy
    end
  end

  context "when using rails < 5" do
    before do
      stub_const("::Rails::VERSION::MAJOR", 4)
      allow(mock).to receive(:belongs_to).and_return(true)
    end

    it "calls belongs_to with correct arguments" do
      setup_association.define_belongs_to

      expect(mock).to have_received(:belongs_to).with(
        :impressionable, { polymorphic: true }
      )
    end

    it "returns truthy when calling define_belongs_to" do
      expect(setup_association.define_belongs_to).to be_truthy
    end

    it "has set as falsy" do
      expect(setup_association.set).to be_falsy
    end
  end
end
