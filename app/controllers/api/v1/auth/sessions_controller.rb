module Api
  module V1
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
        respond_to :json

        private

        def resource_params
          params.permit(:email, :password)
        end

        def render_create_error_bad_credentials
          render json: { errors: ["Invalid login credentials"] }, status: :unauthorized
        end
      end
    end
  end
end
