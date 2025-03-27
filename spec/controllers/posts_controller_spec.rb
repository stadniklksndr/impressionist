# frozen_string_literal: true

require 'spec_helper'

describe PostsController do
  describe "logs impression at the action level" do
    before { get :show, params: { id: 1 } }

    it "logs an impression with the correct count" do
      expect(Impression.all.size).to eq(12)
    end

    it "logs impression with correct controller and action" do
      impression = Impression.last

      aggregate_failures do
        expect(impression.controller_name).to eq("posts")
        expect(impression.action_name).to eq("show")
      end
    end

    it "logs impression with correct impressionable attributes" do
      impression = Impression.last

      aggregate_failures do
        expect(impression.impressionable_type).to eq("Post")
        expect(impression.impressionable_id).to eq(1)
      end
    end
  end

  it "logs the user_id if user is authenticated (current_user helper method)" do
    session[:user_id] = 123
    get :show, params: { id: 1 }

    expect(Post.first.impressions.last.user_id).to eq(123)
  end

  describe "logs impression at the action level with params" do
    before { get :show, params: { id: 1, checked: true } }

    it "logs an impression with the correct count" do
      expect(Impression.all.size).to eq(12)
    end

    it "logs impression with correct controller and action" do
      impression = Impression.last

      aggregate_failures do
        expect(impression.controller_name).to eq "posts"
        expect(impression.action_name).to eq "show"
      end
    end

    it "logs impression with correct impressionable attributes" do
      aggregate_failures do
        expect(Impression.last.params).to eq({ "checked" => "true" })
        expect(Impression.last.impressionable_type).to eq "Post"
        expect(Impression.last.impressionable_id).to eq 1
      end
    end
  end
end
