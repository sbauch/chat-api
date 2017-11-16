# frozen_string_literal: true

class AddIndexesToConversationUser < ActiveRecord::Migration[5.1]
  def change
    add_index :conversation_users, :user_id
    add_index :conversation_users, :conversation_id
  end
end
