FactoryGirl.define do
  factory :term do
    name                        ['Galactic', 'Colony', 'Spaceship', 'Universe', 'MilkyWay'].sample
    definition                  { Faker::Lorem.paragraph }
    source_system               ''
    possible_values             { Faker::Lorem.sentence(1) }
    notes                       { Faker::Lorem.sentence(3) }
    data_availability           { Faker::Lorem.sentence(1) }
    sensitivity_classification  ["Highly Sensitive", "Sensitive", "Internal", "Public", nil].sample
    access_designation          ['Limited', 'Unlimited', nil].sample
    sensitivity_access_notes    { Faker::Company.name }
  end
end
