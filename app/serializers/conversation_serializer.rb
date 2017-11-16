# frozen_string_literal: true

class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
  has_many :participants
  has_many :messages

  def messages
    @object.messages.page(instance_options[:page])
  end
end
