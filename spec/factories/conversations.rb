# frozen_string_literal: true

FactoryGirl.define do
  factory :conversation do
    users { create_list(:user, 2) }
  end
end
