# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  def self.create_in_conversation(conversation_id, sender, content)
    conversation = Conversation.find_by(id: conversation_id)
    sender.messages.new(
      conversation: conversation,
      content: content
    )
  end
end
