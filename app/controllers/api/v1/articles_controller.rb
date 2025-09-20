module Api
  module V1
    class ArticlesController < BaseApiController
      # 一覧・詳細は誰でも見られる
      skip_before_action :authenticate_user!, only: %i[index show]

      before_action :set_article, only: %i[show update destroy]
      before_action :authorize_owner!, only: %i[update destroy]

      # GET /api/v1/articles
      def index
        articles = Article.order(updated_at: :desc)
        render json: articles,
               each_serializer: Api::V1::ArticlePreviewSerializer
      end

      # GET /api/v1/articles/:id
      def show
        render json: @article, serializer: Api::V1::ArticleDetailSerializer
      end

      # POST /api/v1/articles
      def create
        article = current_user.articles.new(article_params)
        return render(json: article, status: :created) if article.save

        render_unprocessable!(article)
      end

      # PATCH/PUT /api/v1/articles/:id
      def update
        return render(json: @article) if @article.update(article_params)

        render_unprocessable!(@article)
      end

      # DELETE /api/v1/articles/:id
      def destroy
        @article.destroy!
        head :no_content
      end

      private

      def set_article
        @article = Article.find(params[:id])
      end

      def authorize_owner!
        return if @article.user_id == current_user.id

        render json: { error: "Forbidden" }, status: :forbidden
      end

      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
