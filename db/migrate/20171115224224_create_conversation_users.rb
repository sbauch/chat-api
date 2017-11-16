# frozen_string_literal: true

class CreateConversationUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_users, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :conversation_id

      t.timestamps
    end
  end
end
