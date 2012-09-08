FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :report do
    latitude 50.853584
    longitude 4.362946
    heading 175
    user
  end
end

