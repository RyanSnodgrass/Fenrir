FactoryGirl.define do
  factory :report do
    name         Faker::Name.title
    description  Faker::Lorem.paragraph 
  end
  factory :tableau_report, class: Report do
    report_type 'Tableau'
  end
end
