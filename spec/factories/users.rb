FactoryBot.define do
  factory :user do
    name { "TestName" }
    sequence(:email){|n| "user#{n}@gmail.com"}
    password_digest { BCrypt::Password.create("12345")}
  end
end