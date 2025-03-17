# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Impressionable" do
  fixtures :widgets

  let(:widget) { Widget.find(1) }

  before do
    Impression.destroy_all
  end

  describe ".impressionist_counter_caching?" do
    it "knows when counter caching is enabled" do
      expect(Widget).to be_impressionist_counter_caching
    end

    it "knows when counter caching is disabled" do
      expect(Article).not_to be_impressionist_counter_caching
    end
  end

  describe ".counter_caching?" do
    let(:deprecation) { instance_double(ActiveSupport::Deprecation, warn: true) }

    context "when enabled" do
      it "is deprecated from 2.0.0" do
        allow(ActiveSupport::Deprecation).to receive(:new).and_call_original
        Widget.counter_caching?

        expect(ActiveSupport::Deprecation).to have_received(:new).with("2.0.0", "impressionist")
      end

      it "returns deprecation warn" do
        allow(ActiveSupport::Deprecation).to receive(:new) { deprecation }
        Widget.counter_caching?

        expect(deprecation).to have_received(:warn).with(
          "#counter_caching? is deprecated; please use #impressionist_counter_caching? instead"
        )
      end

      it { expect(Widget).to be_counter_caching }
    end

    context "when disabled" do
      it "is deprecated from 2.0.0" do
        allow(ActiveSupport::Deprecation).to receive(:new).and_call_original
        Article.counter_caching?

        expect(ActiveSupport::Deprecation).to have_received(:new).with("2.0.0", "impressionist")
      end

      it "returns deprecation warn" do
        allow(ActiveSupport::Deprecation).to receive(:new) { deprecation }
        Widget.counter_caching?

        expect(deprecation).to have_received(:warn).with(
          "#counter_caching? is deprecated; please use #impressionist_counter_caching? instead"
        )
      end

      it { expect(Article).not_to be_counter_caching }
    end
  end

  describe "#update_impressionist_counter_cache" do
    it "updates the counter cache column to reflect the correct number of impressions" do
      expect do
        widget.impressions.create(request_hash: "abcd1234")
        widget.reload
      end.to change(widget, :impressions_count).from(0).to(1)
    end

    it "does not update the timestamp on the impressable" do
      expect do
        widget.impressions.create(request_hash: "abcd1234")
        widget.reload
      end.not_to change(widget, :updated_at)
    end
  end
end
