# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
Article.destroy_all

10.times do |i|
  Article.create!(
    title: "Article #{i + 1}: #{Faker::Lorem.sentence(word_count: 3, random_words_to_add: 2)}",
    body: Faker::Lorem.paragraph_by_chars(number: 1500, supplemental: true),
    tags: "Opinion",
    published: [ true, false ].sample
  )
end

puts "Created #{Article.count} articles"

Admin.create!(email: '')
