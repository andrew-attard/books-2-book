require 'httparty'
require 'faker'
require 'concurrent-ruby'

puts "Cleaning the DB..."
Ownership.destroy_all
Rental.destroy_all
Book.destroy_all
ListItem.destroy_all

class OpenLibraryApi
  include HTTParty
  base_uri 'https://openlibrary.org'

  def search_books(query)
    self.class.get("/search.json", query: { q: query, limit: 1 })
  end

  def get_details(endpoint, id)
    self.class.get("/#{endpoint}/#{id}.json")
  end
end

api = OpenLibraryApi.new
titles = [
  'The Lord of the Rings', 'The Hunger Games', 'The Da Vinci Code', 'The Hobbit', 'Eat, Pray, Love', 'Life of Pi',
  'The Chronicles of Narnia', 'The Kite Runner', 'The Fault in Our Stars', 'Brave New World',
  'Moby Dick', 'Dracula', 'Little Women', 'The Shining', 'The Hitchhiker\'s Guide to the Galaxy', 'Frankenstein',
  'The Stand', 'A Game of Thrones', 'Catching Fire', 'Water for Elephants', 'Mockingjay', 'The Girl on the Train',
  'The Giver', 'The Light Between Oceans', 'The Immortal Life of Henrietta Lacks', 'Alice\'s Adventures in Wonderland',
  'Wuthering Heights', 'The Wind in the Willows', 'The Lion, the Witch, and the Wardrobe', 'Ivanhoe', 'My Ántonia',
  'Fathers and Sons', 'The Trial', 'Country Driving', 'Gulliver\'s Travels', 'The Time Traveler\'s Wife',
  'The Call of the Wild', 'The Great Gatsby', 'The Catcher in the Rye', 'Shoe Dog',
  'Love in the Time of Cholera', 'Beloved', 'The Color Purple', 'The Sound and the Fury',
  'No Country for Old Men', 'Les Misérables', 'An Immense World','The Three Musketeers',
  'War and Peace', 'Madame Bovary'
]

popular_genres = [
  'Fantasy', 'Science Fiction', 'Mystery', 'Thriller', 'Romance', 'Historical', 'Horror', 'Adventure', 'Children',
  'Young Adult', 'Biography', 'Autobiography', 'Contemporary', 'Drama', 'Humor', 'Poetry', 'Epic', 'Self-help',
  'Graphic Novels', 'Memoir', 'Psychology', 'Science', 'Philosophy', 'Religion', 'Spirituality', 'Travel',
  'True Crime', 'Cooking', 'Health', 'Sports', 'Music', 'Photography', 'Crafts', 'Home', 'Gardening', 'Education',
  'Business', 'Economics', 'Politics', 'Law', 'Technology', 'Computers', 'Mathematics', 'Medical'
]

def sanitize_genre_names(genres, popular_genres)
  filtered_genres = genres.flat_map do |genre|
    genre.split(',').map(&:strip).map do |g|
      matched_genre = popular_genres.find do |pop_genre|
        g.downcase.include?(pop_genre.downcase) &&
        !g.downcase.include?('fiction') &&
        !g.include?('(')
      end

      next if matched_genre.nil?
      matched_genre.split.map(&:capitalize).join(' ')
    end
  end.compact.uniq.first(3) # Limit to the first 3 unique genres

  filtered_genres.join(', ').presence || 'Unknown'
end

puts "Starting to seed books..."

book_counter = 0
batch_size = 4

valid_books = []

titles.each_slice(batch_size) do |batch|
  futures = batch.map do |title|
    Concurrent::Promises.future do
      begin
        sleep(0.1)
        search_response = api.search_books(title)
        raise "Search failed for #{title}" unless search_response.success?

        first_result = search_response.parsed_response['docs']&.first
        raise "No search results for #{title}" unless first_result

        book_id = first_result['edition_key']&.first
        work_id = first_result['key']&.split('/')&.last
        author_id = first_result['author_key']&.first
        raise "Missing IDs for #{title}" unless book_id && work_id && author_id

        book_response = api.get_details('books', book_id)
        work_response = api.get_details('works', work_id)
        author_response = api.get_details('authors', author_id)
        raise "Details fetch failed for #{title}" unless book_response.success? && work_response.success? && author_response.success?

        book_data = book_response.parsed_response
        work_data = work_response.parsed_response
        author_data = author_response.parsed_response

        description = work_data['description']
        description = description['value'] if description.is_a?(Hash)
        description = description&.split(' ')&.first(40)&.join(' ') + '...' if description
        description ||= 'No description available'

        author_name = author_data['name'] || 'No author available'

        genres = work_data['subjects'] || []
        genre = sanitize_genre_names(genres, popular_genres)

        isbn = book_data.dig('isbn_10', 0) || book_data.dig('isbn_13', 0) || 'No ISBN available'
        raise "missing ISBN" if isbn == 'No ISBN available'
        next if genre == 'Unknown' || isbn == 'No ISBN available'

        cover_url = "https://covers.openlibrary.org/b/id/#{book_data.dig('covers', 0)}-L.jpg"
        raise "missing cover" if cover_url.include?('nil')

        book = Book.create!(
          title: title,
          author: author_name,
          genre: genre,
          description: description,
          isbn: isbn,
          cover_url: cover_url
        )

        valid_books << book
        book_counter += 1
        puts "Prepared book ##{book_counter}: #{title} with genres: #{genre}"
      rescue StandardError => e
        puts "Skipped book: #{title} due to #{e.message}"
      end
    end
  end

  # Wait for all futures in the batch to complete
  Concurrent::Promises.zip(*futures).value!

  sleep(0.1)
end

conditions = ["Poor", "Fair", "Good", "Excellent", "Mint"]

100.times do
  user = User.create!(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: "123456"
  )
  5.times do
    Ownership.create!(
      book: valid_books.sample,
      user: user,
      price: rand(1..10),
      condition: conditions.sample
    )
  end
end

puts "...Created DB seeds"
