# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Message requests", type: :request do
  let(:current_user) { create(:user_with_conversations) }

  before do
    allow(User).to receive(:current_user).and_return(current_user)
  end

  describe "/message" do
    context "POST" do
      let(:conversation) { create(:conversation) }
      let(:content) { "Hello world!" }

      context "with the required payload" do

        before do
          conversation.users << current_user
          params = { message: {
            conversation_id: conversation.id,
            content: content
          } }
          post "/messages", params: params
        end

        it "returns status 201 created" do
          expect(response).to have_http_status(:created)
        end

        it "returns json" do
          expect(response.content_type).to eq("application/json")
        end

        it "returns the created message" do
          json = JSON.parse(response.body)
          expect(json["message"]["id"].is_a?(String)).to be true
        end

        it "returns the conversation_id" do
          json = JSON.parse(response.body)
          expect(json["message"]["conversation_id"]).to eq(conversation.id)
        end

        it "returns the message content" do
          json = JSON.parse(response.body)
          expect(json["message"]["content"]).to eq(content)
        end

        it "returns the expected message sender" do
          json = JSON.parse(response.body)
          expect(json["message"]["user_id"]).to eq(current_user.id)
        end
      end

      context "without a conversation id" do
        before do
          params = { message: { content: "Hello world" } }
          post "/messages", params: params
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
          ).to match(/Conversation must exist/)
        end
      end

      context "without message content" do
        before do
          params = { message: { conversation_id: conversation.id } }
          post "/messages", params: params
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
          ).to match(/Content can't be blank/)
        end
      end
    end
  end
end
