# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :conversation_users
  has_many :users, through: :conversation_users
  validates :conversation_users, length: { minimum: 2 }
  alias_attribute :participants, :users

  def self.create_with_participant_ids(ids)
    participants = User.where(id: ids)
    create!(participants: participants)
  end

  def to_json
    attributes.merge!(
      participants: participants
    )
  end
end
