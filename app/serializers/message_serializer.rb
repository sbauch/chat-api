class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :created_at, :conversation_id
end
