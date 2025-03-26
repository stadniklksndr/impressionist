# frozen_string_literal: true

require 'spec_helper'

# we use the posts controller as it uses the impressionsist module. any such controller would do.
describe DummyController do
  let!(:impression_count) { Impression.all.size }

  it 'logs impression at the per action level on non-restful controller' do
    get 'index'
    expect(Impression.all.size).to eq 12
  end

  describe "impressionist filter uniqueness" do
    it "ignore uniqueness if not requested" do
      controller.impressionist_subapp_filter
      controller.impressionist_subapp_filter

      expect(Impression.count).to eq(impression_count + 2)
    end

    it "recognize unique session" do
      allow(controller).to receive(:session_hash).and_return(request.session_options[:id])

      controller.impressionist_subapp_filter(unique: [:session_hash])
      controller.impressionist_subapp_filter(unique: [:session_hash])

      expect(Impression.count).to eq(impression_count + 1)
    end

    it "recognize unique ip" do
      allow(request).to receive(:remote_ip).and_return("1.2.3.4")

      controller.impressionist_subapp_filter(unique: [:ip_address])
      controller.impressionist_subapp_filter(unique: [:ip_address])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique request" do
      controller.impressionist_subapp_filter(unique: [:request_hash])
      controller.impressionist_subapp_filter(unique: [:request_hash])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique action" do
      allow(controller).to receive(:action_name).and_return("test_action")

      controller.impressionist_subapp_filter(unique: [:action_name])
      controller.impressionist_subapp_filter(unique: [:action_name])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique controller" do
      allow(controller).to receive(:controller_name).and_return("post")

      controller.impressionist_subapp_filter(unique: [:controller_name])
      controller.impressionist_subapp_filter(unique: [:controller_name])
      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique user" do
      allow(controller).to receive(:user_id).and_return(42)

      controller.impressionist_subapp_filter(unique: [:user_id])
      controller.impressionist_subapp_filter(unique: [:user_id])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique referer" do
      allow(controller.request).to receive(:referer).and_return("http://foo/bar")

      controller.impressionist_subapp_filter(unique: [:referrer])
      controller.impressionist_subapp_filter(unique: [:referrer])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique id" do
      allow(controller).to receive(:params).and_return({ id: "666" }) # for correct impressionable id in filter

      controller.impressionist_subapp_filter(unique: [:impressionable_id])
      controller.impressionist_subapp_filter(unique: [:impressionable_id])
      expect(Impression.count).to equal(impression_count + 1)
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/ReceiveMessages
    # extra redundant test for important controller and action combination.
    it "recognize different controller and action" do
      aggregate_failures do
        # increments impression count by 1 when controller_name is 'post' and action_name is 'test_action'
        allow(controller).to receive_messages(controller_name: "post", action_name: "test_action")
        controller.impressionist_subapp_filter(unique: [:controller_name, :action_name])
        controller.impressionist_subapp_filter(unique: [:controller_name, :action_name])
        expect(Impression.count).to equal(impression_count + 1)

        # increments impression count by 2 when action_name changes to 'another_action'
        allow(controller).to receive(:action_name).and_return("another_action")
        controller.impressionist_subapp_filter(unique: [:controller_name, :action_name])
        controller.impressionist_subapp_filter(unique: [:controller_name, :action_name])
        expect(Impression.count).to equal(impression_count + 2)

        # increments impression count by 3 when controller_name changes to 'article'
        allow(controller).to receive(:controller_name).and_return("article")
        controller.impressionist_subapp_filter(unique: [:controller_name, :action_name])
        controller.impressionist_subapp_filter(unique: [:controller_name, :action_name])
        expect(Impression.count).to equal(impression_count + 3)
      end
    end

    it "recognize different action" do
      aggregate_failures do
        allow(controller).to receive(:action_name).and_return("test_action")
        controller.impressionist_subapp_filter(unique: [:action_name])
        controller.impressionist_subapp_filter(unique: [:action_name])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller).to receive(:action_name).and_return("another_action")
        controller.impressionist_subapp_filter(unique: [:action_name])
        controller.impressionist_subapp_filter(unique: [:action_name])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different controller" do
      aggregate_failures do
        allow(controller).to receive(:controller_name).and_return("post")
        controller.impressionist_subapp_filter(unique: [:controller_name])
        controller.impressionist_subapp_filter(unique: [:controller_name])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller).to receive(:controller_name).and_return("article")
        controller.impressionist_subapp_filter(unique: [:controller_name])
        controller.impressionist_subapp_filter(unique: [:controller_name])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different session" do
      aggregate_failures do
        allow(controller).to receive(:session_hash).and_return("foo")
        controller.impressionist_subapp_filter(unique: [:session_hash])
        controller.impressionist_subapp_filter(unique: [:session_hash])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller).to receive(:session_hash).and_return("bar")
        controller.impressionist_subapp_filter(unique: [:session_hash])
        controller.impressionist_subapp_filter(unique: [:session_hash])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different ip" do
      aggregate_failures do
        allow(controller.request).to receive(:remote_ip).and_return("1.2.3.4")
        controller.impressionist_subapp_filter(unique: [:ip_address])
        controller.impressionist_subapp_filter(unique: [:ip_address])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller.request).to receive(:remote_ip).and_return("5.6.7.8")
        controller.impressionist_subapp_filter(unique: [:ip_address])
        controller.impressionist_subapp_filter(unique: [:ip_address])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different referer" do
      aggregate_failures do
        allow(controller.request).to receive(:referer).and_return("http://foo/bar")
        controller.impressionist_subapp_filter(unique: [:referrer])
        controller.impressionist_subapp_filter(unique: [:referrer])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller.request).to receive(:referer).and_return("http://bar/fo")
        controller.impressionist_subapp_filter(unique: [:referrer])
        controller.impressionist_subapp_filter(unique: [:referrer])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different id" do
      allow(controller).to receive(:params).and_return({ id: "666" }) # for correct impressionable id in filter
      controller.impressionist_subapp_filter(unique: [:impressionable_type, :impressionable_id])
      controller.impressionist_subapp_filter(unique: [:impressionable_type, :impressionable_id])

      allow(controller).to receive(:params).and_return({ id: "42" }) # for correct impressionable id in filter
      controller.impressionist_subapp_filter(unique: [:impressionable_type, :impressionable_id])
      controller.impressionist_subapp_filter(unique: [:impressionable_type, :impressionable_id])

      expect(Impression.count).to equal(impression_count + 2)
    end

    it "recognize combined uniqueness" do
      allow(controller).to receive(:action_name).and_return("test_action")

      controller.impressionist_subapp_filter(unique: [:ip_address, :request_hash, :action_name])
      controller.impressionist_subapp_filter(unique: [:request_hash, :ip_address, :action_name])
      controller.impressionist_subapp_filter(unique: [:request_hash, :action_name])
      controller.impressionist_subapp_filter(unique: [:ip_address, :action_name])
      controller.impressionist_subapp_filter(unique: [:ip_address, :request_hash])
      controller.impressionist_subapp_filter(unique: [:action_name])
      controller.impressionist_subapp_filter(unique: [:ip_address])
      controller.impressionist_subapp_filter(unique: [:request_hash])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize combined non-uniqueness" do
      allow(controller).to receive(:action_name).and_return(nil)
      controller.impressionist_subapp_filter(unique: [:ip_address, :action_name])

      allow(controller).to receive(:action_name).and_return("test_action")
      controller.impressionist_subapp_filter(unique: [:ip_address, :action_name])

      allow(controller).to receive(:action_name).and_return("another_action")
      controller.impressionist_subapp_filter(unique: [:ip_address, :action_name])

      expect(Impression.count).to equal(impression_count + 3)
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/ReceiveMessages
  end

  describe "impressionist method uniqueness for impressionables" do
    # in this test we reuse the post model. might break if model changes.

    it "ignore uniqueness if not requested" do
      impressionable = Post.create
      controller.impressionist impressionable
      controller.impressionist impressionable
      expect(Impression.count).to equal(impression_count + 2)
    end

    it "recognize unique session" do
      allow(controller).to receive(:session_hash).and_return(request.session_options[:id])

      impressionable = Post.create
      controller.impressionist(impressionable, nil, unique: [:session_hash])
      controller.impressionist(impressionable, nil, unique: [:session_hash])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique ip" do
      allow(controller.request).to receive(:remote_ip).and_return("1.2.3.4")

      impressionable = Post.create
      controller.impressionist(impressionable, nil, unique: [:ip_address])
      controller.impressionist(impressionable, nil, unique: [:ip_address])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique request" do
      impressionable = Post.create
      controller.impressionist(impressionable, nil, unique: [:request_hash])
      controller.impressionist(impressionable, nil, unique: [:request_hash])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique user" do
      allow(controller).to receive(:user_id).and_return(666)

      impressionable = Post.create
      controller.impressionist(impressionable, nil, unique: [:user_id])
      controller.impressionist(impressionable, nil, unique: [:user_id])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize unique referer" do
      allow(controller.request).to receive(:referer).and_return("http://foo/bar")

      impressionable = Post.create
      controller.impressionist(impressionable, nil, unique: [:referrer])
      controller.impressionist(impressionable, nil, unique: [:referrer])

      expect(Impression.count).to equal(impression_count + 1)
    end

    # rubocop:disable RSpec/ExampleLength
    it "recognize different session" do
      aggregate_failures do
        impressionable = Post.create

        allow(controller).to receive(:session_hash).and_return("foo")
        controller.impressionist(impressionable, nil, unique: [:session_hash])
        controller.impressionist(impressionable, nil, unique: [:session_hash])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller).to receive(:session_hash).and_return("bar")
        controller.impressionist(impressionable, nil, unique: [:session_hash])
        controller.impressionist(impressionable, nil, unique: [:session_hash])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different ip" do
      aggregate_failures do
        allow(controller.request).to receive(:remote_ip).and_return("1.2.3.4")
        impressionable = Post.create
        controller.impressionist(impressionable, nil, unique: [:ip_address])
        controller.impressionist(impressionable, nil, unique: [:ip_address])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller.request).to receive(:remote_ip).and_return("5.6.7.8")
        controller.impressionist(impressionable, nil, unique: [:ip_address])
        controller.impressionist(impressionable, nil, unique: [:ip_address])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize different user" do
      aggregate_failures do
        impressionable = Post.create

        allow(controller).to receive(:user_id).and_return(666)
        controller.impressionist(impressionable, nil, unique: [:user_id])
        controller.impressionist(impressionable, nil, unique: [:user_id])
        expect(Impression.count).to equal(impression_count + 1)

        allow(controller).to receive(:user_id).and_return(42)
        controller.impressionist(impressionable, nil, unique: [:user_id])
        controller.impressionist(impressionable, nil, unique: [:user_id])
        expect(Impression.count).to equal(impression_count + 2)
      end
    end

    it "recognize combined uniqueness" do
      impressionable = Post.create
      allow(controller).to receive(:session_hash).and_return("foo")

      controller.impressionist(impressionable, nil, unique: [:ip_address, :request_hash, :session_hash])
      controller.impressionist(impressionable, nil, unique: [:request_hash, :ip_address, :session_hash])
      controller.impressionist(impressionable, nil, unique: [:request_hash, :session_hash])
      controller.impressionist(impressionable, nil, unique: [:ip_address, :session_hash])
      controller.impressionist(impressionable, nil, unique: [:ip_address, :request_hash])
      controller.impressionist(impressionable, nil, unique: [:session_hash])
      controller.impressionist(impressionable, nil, unique: [:ip_address])
      controller.impressionist(impressionable, nil, unique: [:request_hash])

      expect(Impression.count).to equal(impression_count + 1)
    end

    it "recognize combined non-uniqueness" do
      impressionable = Post.create
      allow(controller).to receive(:session_hash).and_return(nil)
      controller.impressionist(impressionable, nil, unique: [:ip_address, :session_hash])
      allow(controller).to receive(:session_hash).and_return("foo")
      controller.impressionist(impressionable, nil, unique: [:ip_address, :session_hash])
      allow(controller).to receive(:session_hash).and_return("bar")
      controller.impressionist(impressionable, nil, unique: [:ip_address, :session_hash])
      expect(Impression.count).to equal(impression_count + 3)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe "impressionist filter and method uniqueness" do
    let!(:impressionable) { Post.create }

    before do
      allow(controller).to receive_messages(
        session_hash: "foo",
        controller_name: "post",
        params: { id: impressionable.id.to_s }
      )

      allow(controller.request).to receive(:remote_ip).and_return("1.2.3.4")
    end

    it "recognize uniqueness" do
      # order of the following methods is important for the test!
      controller.impressionist_subapp_filter(unique: [:ip_address, :request_hash, :session_hash])
      controller.impressionist(impressionable, nil, unique: [:ip_address, :request_hash, :session_hash])

      expect(Impression.count).to equal(impression_count + 1)
    end
  end

  describe 'impressionist with friendly id' do
    let(:impressionable) { Profile.create({ username: 'test_profile', slug: 'test_profile' }) }

    before do
      allow(controller).to receive_messages(
        action_name: 'show',
        controller_name: "profile",
        params: { id: impressionable.slug }
      )

      allow(controller.request).to receive(:remote_ip).and_return('1.2.3.4')
    end

    it 'unique' do
      controller.impressionist(impressionable, nil, unique: [:impressionable_type, :impressionable_id])
      controller.impressionist(impressionable, nil, unique: [:impressionable_type, :impressionable_id])

      expect(Impression.count).to equal(impression_count + 1)
    end
  end

  shared_examples_for 'an impressionable action' do
    it 'record an impression' do
      controller.impressionist_subapp_filter(condition)
      expect(Impression.count).to equal(impression_count + 1)
    end
  end

  shared_examples_for 'an unimpressionable action' do
    it 'record an impression' do
      controller.impressionist_subapp_filter(condition)
      expect(Impression.count).to equal(impression_count)
    end
  end

  describe "conditional impressions :if" do
    context "when true condition" do
      before do
        allow(controller).to receive(:send).with(:true_condition).and_return(true)
      end

      it_behaves_like 'an impressionable action' do
        let(:condition) { { if: :true_condition } }
      end

      it_behaves_like 'an impressionable action' do
        let(:condition) { { if: -> { true } } }
      end
    end

    context "when false condition" do
      before do
        allow(controller).to receive(:send).with(:false_condition).and_return(false)
      end

      it_behaves_like 'an unimpressionable action' do
        let(:condition) { { if: :false_condition } }
      end

      it_behaves_like 'an unimpressionable action' do
        let(:condition) { { if: -> { false } } }
      end
    end
  end

  describe "conditional impressions :unless" do
    context "when true condition" do
      before do
        allow(controller).to receive(:send).with(:true_condition).and_return(true)
      end

      it_behaves_like 'an unimpressionable action' do
        let(:condition) { { unless: :true_condition } }
      end

      it_behaves_like 'an unimpressionable action' do
        let(:condition) { { unless: -> { true } } }
      end
    end

    context "when false condition" do
      before do
        allow(controller).to receive(:send).with(:false_condition).and_return(false)
      end

      it_behaves_like 'an impressionable action' do
        let(:condition) { { unless: :false_condition } }
      end

      it_behaves_like 'an impressionable action' do
        let(:condition) { { unless: -> { false } } }
      end
    end
  end
end
