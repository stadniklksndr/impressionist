# frozen_string_literal: false

require "spec_helper"

RSpec.describe ArticlesController do
  fixtures :articles, :impressions, :posts, :widgets

  render_views

  it 'makes the impressionable_hash available' do
    get :index
    expect(response.body).to include('false')
  end

  describe "logs an impression with a message" do
    before { get "index" }

    it "creates an impression" do
      expect(Impression.all.size).to eq(12)
    end

    it "sets the correct impression message" do
      latest_impression = Article.first.impressions.last
      expect(latest_impression.message).to eq("this is a test article impression")
    end

    it "visit the correct controller name" do
      latest_impression = Article.first.impressions.last
      expect(latest_impression.controller_name).to eq("articles")
    end

    it "visit the correct action name" do
      latest_impression = Article.first.impressions.last
      expect(latest_impression.action_name).to eq("index")
    end
  end

  describe "logs an impression without a message" do
    before { get :show, params: { id: 1 } }

    it "creates an impression" do
      expect(Impression.all.size).to eq(12)
    end

    it "sets empty message" do
      latest_impression = Article.first.impressions.last
      expect(latest_impression.message).to be_nil
    end

    it "visit the correct controller name" do
      latest_impression = Article.first.impressions.last
      expect(latest_impression.controller_name).to eq("articles")
    end

    it "visit the correct action name" do
      latest_impression = Article.first.impressions.last
      expect(latest_impression.action_name).to eq("show")
    end
  end

  it 'logs the user_id if user is authenticated (@current_user before_action method)' do
    session[:user_id] = 123
    get :show, params: { id: 1 }

    expect(Article.first.impressions.last.user_id).to eq(123)
  end

  it 'does not log the user_id if user is authenticated' do
    get :show, params: { id: 1 }

    expect(Article.first.impressions.last.user_id).to be_nil
  end

  describe "logs the request_hash, ip_address, referrer and session_hash" do
    before { get :show, params: { id: 1 } }

    it 'logs the request_hash' do
      expect(Impression.last.request_hash.size).to eq(64)
    end

    it "logs the ip_address" do
      expect(Impression.last.ip_address).to eq('0.0.0.0')
    end

    it "logs the session_hash" do
      expect(Impression.last.session_hash.size).to eq(32)
    end

    it "logs the referrer" do
      expect(Impression.last.referrer).to be_nil
    end
  end

  it 'logs the referrer when you click a link', type: :system do
    visit article_url(Article.first, host: "test.host")
    click_link 'Same Page'
    expect(Impression.last.referrer).to eq 'http://test.host/articles/1'
  end

  describe "logs request with params (checked = true)" do
    before { get :show, params: { id: 1, checked: true } }

    it "logs the request params" do
      expect(Impression.last.params).to eq({ "checked" => "true" })
    end

    it "logs the request_hash" do
      expect(Impression.last.request_hash.size).to eq(64)
    end

    it "logs the ip_address" do
      expect(Impression.last.ip_address).to eq("0.0.0.0")
    end

    it "logs the session_hash" do
      expect(Impression.last.session_hash.size).to eq(32)
    end

    it "logs the referrer" do
      expect(Impression.last.referrer).to be_nil
    end
  end

  describe "logs request with params: {}" do
    before { get "index" }

    it "logs the request params" do
      expect(Impression.last.params).to eq({})
    end

    it "logs the request_hash" do
      expect(Impression.last.request_hash.size).to eq(64)
    end

    it "logs the ip_address" do
      expect(Impression.last.ip_address).to eq("0.0.0.0")
    end

    it "logs the session_hash" do
      expect(Impression.last.session_hash.size).to eq(32)
    end

    it "logs the referrer" do
      expect(Impression.last.referrer).to be_nil
    end
  end

  describe 'when filtering params' do
    let!(:filter_parameters) { Rails.application.config.filter_parameters }

    before do
      Rails.application.config.filter_parameters = [:password]
    end

    after do
      Rails.application.config.filter_parameters = filter_parameters
    end

    it 'values should not be recorded' do
      get 'index', params: { password: 'best-password-ever' }
      expect(Impression.last.params).to eq('password' => '[FILTERED]')
    end
  end
end
