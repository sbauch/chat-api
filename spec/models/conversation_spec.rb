# frozen_string_literal: true

require "rails_helper"

RSpec.describe Conversation, type: :model do

  describe "::create_with_participant_ids" do
    let(:users) { create_list(:user, 8) }

    context "when provided > 1 valid participant ids" do
      subject {
        described_class.create_with_participant_ids(users.map(&:id))
      }

      it "returns a Conversation" do
        expect(subject.is_a?(Conversation)).to be true
      end

      it "including the expected particpants" do
        expect(subject.participants).to eq(users)
      end
    end

    context "when provided < 2 particpant ids" do
      it "raises a validation error" do
        expect {
          described_class.create_with_participant_ids([users.first.id])
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when provided < 2 valid particpants" do
      it "raises a validation error" do
        expect {
          described_class.create_with_participant_ids([
            users.first.id, "invalid-user-uuid"
          ])
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
