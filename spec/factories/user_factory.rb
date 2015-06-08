FactoryGirl.define do
  factory :user do
    net_id Faker::Name.name
  end
  factory :anonymous, class: User do
    net_id 'anonymous'
  end
end
