namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    50.times do |n|
      name  = Faker::Name.name
      email = "user#{n+1}@example.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
