# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username
      t.string :avatar_url

      t.timestamps
    end
  end
end
