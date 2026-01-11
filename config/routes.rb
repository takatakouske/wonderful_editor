Rails.application.routes.draw do
  root to: "home#index"

  # reload 対策
  get "sign_up", to: "home#index"
  get "sign_in", to: "home#index"
  get "articles/new", to: "home#index"
  get "articles/:id", to: "home#index"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
        sessions:      "api/v1/auth/sessions"
      }
      resources :articles
      # 下書き一覧と詳細（自分の分のみ）
　　　　get 'articles/drafts',     to: 'api/v1/articles/drafts#index'
　　　　get 'articles/drafts/:id', to: 'api/v1/articles/drafts#show'
    end
  end
end
