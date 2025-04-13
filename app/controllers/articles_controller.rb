class ArticlesController < ApplicationController
  def index
    @articles = Article.all

    @articles = params[:sort] == "oldest" ? @articles.oldest : @articles.newest

    if params[:status] == "draft" && admin_logged_in?
      @articles = @articles.where(published: false)
    else
      @articles = @articles.where(published: true)
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path, notice: "Article was successfully terminated by the Death Star"
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :published, :tags, images: [])
  end
end
