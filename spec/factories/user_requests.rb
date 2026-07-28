FactoryBot.define do
  factory :user_request do
    sequence(:email) { |n| "requester#{n}@example.com" }
    first_name { "Test" }
    last_name { "User" }
    purpose { "Access" }
    reason { "I need access" }
    reviewed { false }
    approved { false }
  end
end
