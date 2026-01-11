module Api
  module V1
    module Articles
      class DraftsController < ::Api::V1::BaseApiController
        before_action :authenticate_user!

        # GET /api/v1/articles/drafts
        def index
          articles = current_user.articles.draft.order(id: :desc)
          render json: articles
        end

        # GET /api/v1/articles/drafts/:id
        def show
          article = current_user.articles.draft.find(params[:id])
          render json: article
        end
      end
    end
  end
end
