FactoryGirl.define do
  factory :goal do
    title Faker::Company.catch_phrase
    description Faker::Lorem.sentence
    association :author, factory: :user
    private [true, false].sample
  end

end
