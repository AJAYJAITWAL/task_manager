FactoryBot.define do
  factory :ticket do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { :new_unassigned }
    user
  end
end
