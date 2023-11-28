FactoryBot.define do
  factory :task do
    tasks {"learn Rspec"}
    association :user

    trait :completed do
      status { :completed }
    end

    trait :pending do
      status { :pending }
    end

    trait :in_progress do
      status { :inprogress }
    end

    trait :discarded do
      status { :discarded }
    end
  end
end
