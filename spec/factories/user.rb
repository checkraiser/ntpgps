FactoryGirl.define do
  factory :user do
    name Faker.name
    email  Faker::Internet.email
    password '123456'
  end
end