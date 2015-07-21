FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password "star_wars"

    factory :bill_gates do
      email "billgates@gmail.com"
      password "star_wars"
    end
  end
end
