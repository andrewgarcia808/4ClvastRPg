class ArticlesController < ApplicationController
  before_action :disallow_modification, only: [:update, :destroy]
  def index
    @articles = Article.order(published_at: :desc)
    render json: @articles
  end

  def show
    @article = Article.find(params[:id])

    render json: @article
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Article not found' }, status: :not_found
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      render json: @article
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])

    @article.destroy
    head :ok
  end

  private

  def disallow_modification
    render json: { error: 'Article modification is not allowed' }, status: :method_not_allowed
  end

  def status_of(article)
    article.valid? ? :created : :unprocessable_entity
  end

  def article_params
    params.permit(:title, :content, :author, :category, :published_at)
  end
end
