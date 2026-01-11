module Api
  module V1
    module Articles
      class DraftsController < BaseApiController
        before_action :authenticate_user!

        def index
          # enum スコープ版
          articles = current_user.articles.draft.order(created_at: :desc)
          render json: articles
        end

        def show
          # enum スコープ版
          article = current_user.articles.draft.find(params[:id])
          render json: article
        end
      end
    end
  end
end
