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

    # add 20 reports to the first 10 users
    users = User.all(limit: 10)
    r = Random.new

    20.times do |n|
      lat = r.rand(-90.0..90.0)
      lng = r.rand(-180.0..180.0)
      heading = r.rand(0...360)
      users.each { |user| user.reports.create!(latitude: lat, longitude: lng, heading: heading) }
    end
  end
end
