# frozen_string_literal: true

require "spec_helper"

describe WidgetsController do
  # rubocop:disable RSpec/ExampleLength
  it "logs impression at the per action level" do
    aggregate_failures do
      get :show, params: { id: 1 }
      expect(Impression.all.size).to eq(12)

      get :index
      expect(Impression.all.size).to eq(13)

      get :new
      expect(Impression.all.size).to eq(13)
    end
  end
  # rubocop:enable RSpec/ExampleLength

  it "does not log impression when user-agent is in wildcard list" do
    request.env["HTTP_USER_AGENT"] = "somebot"

    get :show, params: { id: 1 }
    expect(Impression.all.size).to eq 11
  end

  it "does not log impression when user-agent is in the bot list" do
    request.env["HTTP_USER_AGENT"] = "Acoon Robot v1.50.001"

    get :show, params: { id: 1 }
    expect(Impression.all.size).to eq 11
  end

  # rubocop:disable RSpec/ExampleLength, RSpec/RepeatedExample
  describe "impressionist unique options" do
    it "logs unique impressions at the per action level" do
      aggregate_failures do
        get :show, params: { id: 1 }
        expect(Impression.all.size).to eq(12)

        get :show, params: { id: 2 }
        expect(Impression.all.size).to eq(13)

        get :show, params: { id: 2 }
        expect(Impression.all.size).to eq(13)

        get :index
        expect(Impression.all.size).to eq(14)
      end
    end

    it "logs unique impressions only once per id" do
      aggregate_failures do
        get :show, params: { id: 1 }
        expect(Impression.all.size).to eq(12)

        get :show, params: { id: 2 }
        expect(Impression.all.size).to eq(13)

        get :show, params: { id: 2 }
        expect(Impression.all.size).to eq(13)

        get :index
        expect(Impression.all.size).to eq(14)
      end
    end
  end

  describe "Impresionist unique params options" do
    it "logs unique impressions at the per action and params level" do
      aggregate_failures do
        get :show, params: { id: 1 }
        expect(Impression.all.size).to eq(12)

        get :show, params: { id: 2, checked: true }
        expect(Impression.all.size).to eq(13)

        get :show, params: { id: 2, checked: false }
        expect(Impression.all.size).to eq(14)

        get :index
        expect(Impression.all.size).to eq(15)
      end
    end

    it "does not log impression for same params and same id" do
      aggregate_failures do
        get :show, params: { id: 1 }
        expect(Impression.all.size).to eq(12)

        get :show, params: { id: 1 }
        expect(Impression.all.size).to eq(12)

        get :show, params: { id: 1, checked: true }
        expect(Impression.all.size).to eq(13)

        get :show, params: { id: 1, checked: false }
        expect(Impression.all.size).to eq(14)

        get :show, params: { id: 1, checked: true }
        expect(Impression.all.size).to eq(14)

        get :show, params: { id: 1, checked: false }
        expect(Impression.all.size).to eq(14)

        get :show, params: { id: 1 }
        expect(Impression.all.size).to eq(14)

        get :show, params: { id: 2 }
        expect(Impression.all.size).to eq(15)
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/RepeatedExample
end
