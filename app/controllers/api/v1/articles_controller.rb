module Api
  module V1
    class ArticlesController < BaseApiController
      # 一覧は誰でも見られる
      skip_before_action :authenticate_user!, only: [:index]

      before_action :set_article, only: [:show, :update, :destroy]
      before_action :authorize_owner!, only: [:update, :destroy]

      def index
        articles = Article.order(updated_at: :desc)
        render json: articles,
               each_serializer: Api::V1::ArticlePreviewSerializer
      end

      def show
        render json: @article.as_json(
          only: [:id, :title, :body, :created_at, :updated_at],
          include: { user: { only: [:id, :name, :email] } }
        )
      end

      def create
        article = current_user.articles.new(article_params)
        return render(json: article, status: :created) if article.save
        render_unprocessable!(article)
      end

      def update
        return render(json: @article) if @article.update(article_params)
        render_unprocessable!(@article)
      end

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
        render json: { error: 'Forbidden' }, status: :forbidden
      end

      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
