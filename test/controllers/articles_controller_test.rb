require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one) # Assuming a fixture named :one exists
  end

  test "should get index" do
    get articles_url
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: "New Title",
          body: "This is a new article body that meets the minimum length requirement.",
          published: true,
          tags: "test"
        }
      }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should not create article with invalid params" do
    assert_no_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: "",
          body: "Short",
          published: true,
          tags: "test"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Check for the error div with the correct class
  end

  test "should update article with valid params" do
    patch article_url(@article), params: {
      article: {
        title: "Updated Title",
        body: "This is an updated article body that meets the minimum length requirement."
      }
    }
    assert_redirected_to article_url(@article)
    @article.reload
    assert_equal "Updated Title", @article.title
  end

  test "should not update article with invalid body" do
    patch article_url(@article), params: {
      article: {
        title: "Valid Title",
        body: "Short"
      }
    }
    assert_response :unprocessable_entity
    @article.reload
    assert_not_equal "Short", @article.body.to_plain_text
    assert_select ".bg-red-50" do
      assert_select "li", /Body is too short/
    end
  end

  test "should not update article with invalid title" do
    patch article_url(@article), params: {
      article: {
        title: "",
        body: "This is a valid body with more than ten characters."
      }
    }
    assert_response :unprocessable_entity
    assert_select ".bg-red-50" do
      assert_select "li", /Title can't be blank/
    end
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end
end
