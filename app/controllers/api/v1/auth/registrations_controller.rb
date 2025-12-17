module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        protect_from_forgery with: :null_session

        private

        # devise_token_auth でも Devise の sanitizer を使えます
        def sign_up_params
          params.permit(:email, :password, :password_confirmation, :name)
        end
      end
    end
  end
end
