FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-#{n}@example.com" }
    password               { "000000" }
    password_confirmation  { "000000" }
  end
end
