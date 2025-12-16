module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        # ★ CSRFをAPI(JSON)では無効化
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token

        private

        # name を許可（name をバリデーションしている場合）
        def sign_up_params
          params.permit(:email, :password, :password_confirmation, :name)
        end

        def account_update_params
          params.permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
