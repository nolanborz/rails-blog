ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    # Set up rich text content for fixtures that need it
    @article = articles(:one)
    @article.body = ActionText::Content.new("This is a sample article body that meets the minimum length requirement.")
    @article.save

    @article_two = articles(:two)
    @article_two.body = ActionText::Content.new("This is another article body that also meets the minimum length requirement.")
    @article_two.save
  end

  # Add more helper methods to be used by all tests here...
end
