# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, type: :model do
  describe "::create_in_conversation" do
    let(:conversation) { create(:conversation) }
    let(:sender) { create(:user) }
    let(:content) { "Hello World!" }

    context "when provided a conversation_id, a sender, and content" do
      subject {
        described_class.create_in_conversation(conversation.id, sender, content)
      }

      it "returns a Message" do
        expect(subject.is_a?(Message)).to be true
      end

      it "that is not persisted" do
        expect(subject).to_not be_persisted
      end

      it "including the expected content" do
        expect(subject.content).to eq(content)
      end

      it "from the expected sender" do
        expect(subject.user).to eq(sender)
      end
    end

    context "when provided an invalid conversation id" do
      subject { described_class.create_in_conversation(
        "fake-convo-uuid", sender, content
      ) }

      it "initializes an invalid message" do
        expect(subject).to be_invalid
      end
    end
  end
end
