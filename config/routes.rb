Rails.application.routes.draw do
  root to: "home#index"

  # SPAのリロード対策（フロントのURLをサーバ側で受けてindexへ）
  get "sign_up",      to: "home#index"
  get "sign_in",      to: "home#index"
  get "articles/new", to: "home#index"
  get "articles/:id", to: "home#index"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
        sessions:      "api/v1/auth/sessions"
      }

      # 記事API（公開のみ index/show、作成更新削除は認証で）
      resources :articles, only: %i[index show create update destroy]

      # 下書きAPI（自分の下書きのみ）
      namespace :articles do
        get  "drafts",     to: "drafts#index"
        get  "drafts/:id", to: "drafts#show"
      end
    end
  end
end
