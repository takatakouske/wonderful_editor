require 'rails_helper'

RSpec.describe 'API::V1::Articles', type: :request do
  let!(:user)     { User.create!(email: 'user1@example.com', name: 'User One', password: 'password', password_confirmation: 'password') }
  let!(:article)  { Article.create!(title: 'T1', body: 'B1', user: user) }

  # devise_token_auth のトークン系ヘッダー（ログイン済み想定）
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /api/v1/articles' do
    it '公開APIなのでヘッダー不要で 200 OK' do
      get '/api/v1/articles'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /api/v1/articles/:id' do
    it '公開APIなのでヘッダー不要で 200 OK' do
      get "/api/v1/articles/#{article.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/articles' do
    let(:params) { { article: { title: 'New', body: 'Body' } } }

    context '認証あり' do
      it '201 Created を返す' do
        post '/api/v1/articles', params: params, headers: auth_headers, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context '認証なし' do
      it '401 Unauthorized を返す' do
        post '/api/v1/articles', params: params, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/articles/:id' do
    let(:params) { { article: { title: 'Updated' } } }

    context '認証あり（本人記事）' do
      it '200 OK を返す' do
        patch "/api/v1/articles/#{article.id}", params: params, headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context '認証なし' do
      it '401 Unauthorized を返す' do
        patch "/api/v1/articles/#{article.id}", params: params, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/articles/:id' do
    context '認証あり（本人記事）' do
      it '204 No Content を返す' do
        delete "/api/v1/articles/#{article.id}", headers: auth_headers
        expect(response).to have_http_status(:no_content)
      end
    end

    context '認証なし' do
      it '401 Unauthorized を返す' do
        delete "/api/v1/articles/#{article.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
