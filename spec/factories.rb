FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    roles Role.viewer

    factory :reporter do
      roles Role.reporter
    end

    factory :admin do
      roles Role.admin
    end
  end

  factory :report do
    latitude 50.853584
    longitude 4.362946
    heading 175
    user
  end

  factory :incident do
    latitude 50.853584
    longitude 4.362946
    radius 200
    #avg_lat 0.0
    #avg_lng 0.0
    #std_dev 0.0
  end
end

