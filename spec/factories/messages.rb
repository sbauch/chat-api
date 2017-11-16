# frozen_string_literal: true

FactoryGirl.define do
  factory :message do
    user_id ""
    conversation_id ""
    content "MyText"
  end
end
