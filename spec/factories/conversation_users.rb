# frozen_string_literal: true

FactoryGirl.define do
  factory :conversation_user do
    association :user
    association :conversation
  end
end
