# frozen_string_literal: true

class ConversationUser < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
end
