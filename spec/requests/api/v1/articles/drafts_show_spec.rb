require 'rails_helper'

RSpec.describe 'API::V1::Articles::Drafts#show', type: :request do
  let!(:me)      { User.create!(email: 'me@example.com',  name: 'Me',  password: 'password', password_confirmation: 'password') }
  let!(:other)   { User.create!(email: 'you@example.com', name: 'You', password: 'password', password_confirmation: 'password') }

  let!(:my_d1)   { Article.create!(title: 'D1', body: 'B', user: me,    status: :draft) }
  let!(:your_d1) { Article.create!(title: 'OD', body: 'B', user: other, status: :draft) }
  let!(:my_p1)   { Article.create!(title: 'P1', body: 'B', user: me,    status: :published) }

  let(:auth_headers) { me.create_new_auth_token }

  context '認証あり' do
    it '自分の下書きは 200 で内容を返す' do
      get "/api/v1/articles/drafts/#{my_d1.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['id']).to eq(my_d1.id)
    end

    it '他人の下書きは 404 を返す' do
      get "/api/v1/articles/drafts/#{your_d1.id}", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it '公開記事IDを叩いても 404（このエンドポイントは下書き専用）' do
      get "/api/v1/articles/drafts/#{my_p1.id}", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  context '認証なし' do
    it '401 を返す' do
      get "/api/v1/articles/drafts/#{my_d1.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
