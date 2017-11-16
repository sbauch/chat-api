# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Conversation requests", type: :request do
  let(:current_user) { create(:user_with_conversations) }

  before do
    allow(User).to receive(:current_user).and_return(current_user)
  end

  describe "/conversations" do
    context "GET" do
      before { get "/conversations" }

      it "returns status 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns json" do
        expect(response.content_type).to eq("application/json")
      end

      it "returns the current users's conversations" do
        json = JSON.parse(response.body)
        expect(json["conversations"].map { |c| c["id"] }).to eq(
          current_user.conversations.pluck(:id)
        )
      end
    end
  end

  describe "/conversations" do
    context "POST" do
      let(:users) { create_list(:user, 2) }

      context "with the required payload" do

        before do
          params = { conversation: { recipients: users.map(&:id) } }
          post "/conversations", params: params
        end

        it "returns status 201 created" do
          expect(response).to have_http_status(:created)
        end

        it "returns json" do
          expect(response.content_type).to eq("application/json")
        end

        it "returns the created conversation id" do
          json = JSON.parse(response.body)
          expect(json["conversation"]["id"].is_a?(String)).to be true
        end

        it "returns the created conversation participants" do
          json = JSON.parse(response.body)
          expect(
            json["conversation"]["participants"].map { |u| u["id"] }
          ).to match_array((users << current_user).map(&:id))
        end
      end

      context "without recipient_ids" do
        before do
          params = { conversation: { recipients: [] } }
          post "/conversations", params: params
        end

        it "returns a 500 status" do
          expect(response).to have_http_status(500)
        end

        it "returns json" do
          expect(response.content_type).to eq("application/json")
        end

        it "returns the expected error" do
          json = JSON.parse(response.body)
          expect(
            json["errors"].first
          ).to match(/does not meet minimum participant requirement/)
        end
      end

      context "without an invalid recipient_id" do
        before do
          params = { conversation: { recipients: ["invalid-user-id"] } }
          post "/conversations", params: params
        end

        it "returns a 500 status" do
          expect(response).to have_http_status(500)
        end

        it "returns json" do
          expect(response.content_type).to eq("application/json")
        end

        it "returns the expected error" do
          json = JSON.parse(response.body)
          expect(
            json["errors"].first
          ).to match(/does not meet minimum participant requirement/)
        end
      end
    end
  end

  describe "/conversation/:id" do
    context "GET" do
      let(:conversation) { create(:conversation) }
      let!(:messages) { create_list(
        :message,
        55, # for testing pagination
        conversation: conversation,
        user: current_user
      ) }

      before do
        conversation.users << current_user
        get "/conversations/#{conversation.id}"
      end

      it "returns status 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns json" do
        expect(response.content_type).to eq("application/json")
      end

      it "returns the conversation" do
        json = JSON.parse(response.body)
        expect(json["conversation"]["id"]).to eq(
          conversation.id
        )
      end

      it "returns the 50 most recent messages in descending order" do
        json = JSON.parse(response.body)
        ordered_message_ids = messages.sort do |a, b|
          b.created_at <=> a.created_at
        end.map(&:id).first(50)
        expect(
          json["conversation"]["messages"].map { |m| m["id"] }
        ).to eq(ordered_message_ids)
      end

      it "returns pagination links to load more messages" do
        expected_meta = {
          "current_page" => 1,
          "next_page" => 2,
          "prev_page" => nil,
          "total_pages" => 2,
          "total_count" => 55
        }

        json = JSON.parse(response.body)
        expect(json["meta"]).to eq(expected_meta)
      end

      context "for the second page of messages" do
        before do
          conversation.users << current_user
          params = { page: 2 }
          get "/conversations/#{conversation.id}", params: params
        end

        it "returns the 5 oldest messages in descending order" do
          json = JSON.parse(response.body)
          ordered_message_ids = messages.sort do |a, b|
            b.created_at <=> a.created_at
          end.map(&:id).last(5)

          expect(
            json["conversation"]["messages"].map { |m| m["id"] }
          ).to eq(ordered_message_ids)
        end
      end
    end
  end
end
