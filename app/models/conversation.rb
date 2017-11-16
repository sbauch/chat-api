# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messages, -> { order "created_at desc" }
  has_many :conversation_users
  has_many :users, through: :conversation_users
  validates :conversation_users, length: {
    minimum: 2,
    message: "does not meet minimum participant requirement of at least 2 users"
  }
  alias_attribute :participants, :users

  def self.new_with_participant_ids(ids)
    participants = User.where(id: ids)
    new(participants: participants)
  end
end
