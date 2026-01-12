module Api
  module V1
    module Current
      class ArticlesController < ::Api::V1::BaseApiController
        before_action :authenticate_user!

        def index
          articles = current_user.articles.published.order(created_at: :desc)
          render json: articles
        end
      end
    end
  end
end
