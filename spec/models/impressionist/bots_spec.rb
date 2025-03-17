# frozen_string_literal: true

require "spec_helper"

require "./app/models/impressionist/bots"

RSpec.describe Impressionist::Bots do
  describe "bot detection" do
    it "matches wild card" do
      expect(described_class).to be_bot("google.com bot")
    end

    it "matches a bot list" do
      expect(described_class).to be_bot("A-Online Search")
    end

    context "when inputs do not match a bot" do
      it "skips when no user agent is provided" do
        expect(described_class).not_to be_bot
      end

      it "skips when the user agent is an empty string" do
        expect(described_class).not_to be_bot("")
      end

      it "skips when the user agent is nil" do
        expect(described_class).not_to be_bot(nil)
      end
    end

    it "skips safe matches" do
      expect(described_class).not_to be_bot('127.0.0.1')
    end
  end
end
