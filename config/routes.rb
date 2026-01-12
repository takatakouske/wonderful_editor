# config/routes.rb
Rails.application.routes.draw do
  root to: "home#index"

  # Vueのhistory用（必要ならそのまま）
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

      # 既存：下書きの一覧/詳細
      namespace :articles do
        resources :drafts, only: %i[index show], controller: "drafts"
      end

      # ★ 追加：自分の“公開記事”一覧
      namespace :current do
        resources :articles, only: [:index], controller: "articles"
      end

      # 既存：公開API（index/show は公開・ create/update/destroy は要認証）
      resources :articles
    end
  end
end
