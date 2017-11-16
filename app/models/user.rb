# frozen_string_literal: true

class User < ApplicationRecord
  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_many :messages

  def self.current_user
    # mostly for mocking in tests
    User.first
  end
end
