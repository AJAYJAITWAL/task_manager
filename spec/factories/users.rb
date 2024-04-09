FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "password" }
    role { :user }
  end
end
