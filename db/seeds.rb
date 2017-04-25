password = "password"

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              password,
             password_confirmation: password,
             activated: true,
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true)
end
