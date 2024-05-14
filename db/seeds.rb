require 'httparty'
require 'faker'

puts "Cleaning the DB..."
Ownership.destroy_all
User.destroy_all
Book.destroy_all

class OpenLibraryApi
  include HTTParty
  base_uri 'https://openlibrary.org'

  def search_books(query, limit = 10)
    self.class.get("/search.json", query: { q: query, limit: limit })
  end
end

puts 'Seeding DB...'

api = OpenLibraryApi.new
response = api.search_books('programming', 10)

books_data = response.parsed_response['docs']

books_data.each do |book_data|
  Book.create!(
    title: book_data['title'],
    author: book_data['author_name']&.join(', '),
    genre: book_data['subject']&.first || 'Unknown',
    description: book_data['first_sentence']&.first || 'No description available',
    isbn: book_data['isbn']&.first || 'No ISBN available'
  )
end

conditions = ["Poor", "Fair", "Good", "Excellent", "Mint"]
price_generator = -> { "$#{rand(1..10)}" }

20.times do
  user = User.create!(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: "123456"
  )
  Ownership.create!(
    book: Book.all.sample,
    user: user,
    price: price_generator.call,
    condition: conditions.sample
  )
end

puts "...Created DB seeds"
