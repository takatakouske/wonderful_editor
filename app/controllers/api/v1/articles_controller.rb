module Api
  module V1
    class ArticlesController < BaseApiController
      # 作成/更新/削除だけログイン必須
      before_action :authenticate_user!, only: %i[create update destroy]

      def index
        render json: Article.all
      end

      def show
        article = Article.find(params[:id])
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
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
