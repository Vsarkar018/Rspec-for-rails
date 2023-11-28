FactoryBot.define do
  factory :task do
    tasks { "Complete the Code" }
    user { nil }
    status { 1 }
  end
end
