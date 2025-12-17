module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        # ←これでCSRF検証そのものをスキップ（例外にも行かない）
        skip_before_action :verify_authenticity_token, raise: false
        protect_from_forgery with: :null_session
        respond_to :json

        private

        def sign_up_params
          params.permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
