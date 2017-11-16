# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations, id: :uuid do |t|

      t.timestamps
    end
  end
end
