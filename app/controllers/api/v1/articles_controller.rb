module Api
  module V1
    class ArticlesController < BaseApiController
      # 作成/更新/削除だけログイン必須
      before_action :authenticate_user!, only: %i[create update destroy]

      def index
        # 公開記事のみ
        articles = Article.published.order(created_at: :desc)
        render json: articles
      end

      def show
        # 公開記事のみ
        article = Article.published.find(params[:id])
        render json: article
      end

      def create
        article = current_user.articles.create!(article_params)
        render json: article, status: :created
      end

      def update
        article = current_user.articles.find(params[:id])
        article.update!(article_params)
        render json: article
      end

      def destroy
        article = current_user.articles.find(params[:id])
        article.destroy!
        head :no_content
      end

      private

      def article_params
        # status を許可していることを再確認
        params.require(:article).permit(:title, :body, :status)
      end
    end
  end
end
