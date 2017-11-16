# frozen_string_literal: true

require "rails_helper"

RSpec.describe Conversation, type: :model do

  describe "::new_with_participant_ids" do
    let(:users) { create_list(:user, 8) }

    context "when provided > 1 valid participant ids" do
      subject {
        described_class.new_with_participant_ids(users.map(&:id))
      }

      it "returns a Conversation" do
        expect(subject.is_a?(Conversation)).to be true
      end

      it "that is not persisted" do
        expect(subject).to_not be_persisted
      end

      it "including the expected particpants" do
        expect(subject.participants).to eq(users)
      end
    end

    context "when provided < 2 particpant ids" do
      subject { described_class.new_with_participant_ids([users.first.id]) }

      it "initializes an invalid Conversation" do
        expect(subject).to be_invalid
      end
    end

    context "when provided < 2 valid particpants" do
      subject { described_class.new_with_participant_ids([
          users.first.id, "invalid-user-uuid"
        ])
      }

      it "initializes an invalid Conversation" do
        expect(subject).to be_invalid
      end
    end
  end
end
