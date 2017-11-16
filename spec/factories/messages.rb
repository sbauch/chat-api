# frozen_string_literal: true

FactoryGirl.define do
  factory :message do
    conversation
    user
    content "MyText"
    created_at { Time.now - rand(1..10).hours }
  end
end
