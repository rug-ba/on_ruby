FactoryGirl.define do
  factory :event do
    name        { Faker::Lorem.words(6).join }
    date        { rand(3).days.from_now }
    description { Faker::Lorem.sentences(3).join }
    association :location
    association :user
    created_at  { Time.now }
    updated_at  { Time.now }
  end

  factory :event_with_participants, parent: :event do |event|
    after(:create) { |e| 3.times { FactoryGirl.create(:participant, event: e) } }
  end

  factory :closed_event, parent: :event do |event|
    limit 0
  end
end
