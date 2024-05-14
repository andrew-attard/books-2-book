require 'faker'

puts "Cleaning the DB..."
Book.destroy_all
User.destroy_all
Ownership.destroy_all

puts 'Seeding DB...'
10.times do
  Book.create!(
    title: Faker::Book.title,
    author: Faker::Book.author,
    genre: Faker::Book.genre
  )
end

conditions = ["Poor", "Fair", "Good", "Excellent", "Mint"]
price_generator = "$#{rand(1..10)}"
# Seed Users, Ownerships
20.times do
  user = User.create!(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: Faker::Internet.password
  )
  Ownership.create!(
    book: Book.all.sample,
    user: user,
    price: price_generator,
    condition: conditions.sample
  )
end

puts "...Created DB seeds"
