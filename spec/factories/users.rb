FactoryBot.define do
  factory :user do
    email                  { "test@gamil.com" }
    password               { "000000" }
    password_confirmation  { "000000" }
  end
end
