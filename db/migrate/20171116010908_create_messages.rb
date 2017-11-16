# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :conversation_id
      t.text :content

      t.timestamps
    end
  end
end
