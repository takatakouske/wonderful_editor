module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token

        private

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
