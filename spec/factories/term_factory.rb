FactoryGirl.define do
  factory :term do
    name                        Faker::Lorem.word
    definition                  Faker::Lorem.paragraph 
    source_system               ''
    possible_values             Faker::Lorem.sentence(1)
    notes                       Faker::Lorem.sentence(3)
    data_availability           Faker::Lorem.sentence(1)
    sensitivity_classification  Faker::Company.name
    access_designation          Faker::Company.name
    sensitivity_access_notes    Faker::Company.name
  end
end
