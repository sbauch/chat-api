# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :content, presence: true

  def self.new_in_conversation(conversation_id, sender, content)
    conversation = Conversation.find_by(id: conversation_id)
    sender.messages.new(
      conversation: conversation,
      content: content
    )
  end
end
