FactoryBot.define do
  factory :task do
    association :user
    sequence(:title) { |n| "test_title_#{n}" }
    content { 'test_content' }
    status { 'todo' }
    deadline { Time.now }
  end
end
