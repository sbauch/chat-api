# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    id { SecureRandom.uuid }
    sequence(:username, "a") { |n| "user-" + n }

    factory :user_with_conversations do
      after(:create) { |user| user.conversations << create_list(:conversation, 5) }
    end
  end
end
