require 'rails_helper'

RSpec.describe 'API::V1::Articles#create', type: :request do
  let!(:user) { User.create!(email: 'u1@example.com', name: 'U1', password: 'password', password_confirmation: 'password') }
  let(:auth_headers) { user.create_new_auth_token }

  context '認証あり' do
    it 'status: draft で作成できる（201）' do
      params = { article: { title: 'T', body: 'B', status: 'draft' } }
      post '/api/v1/articles', params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json['status']).to eq('draft')
      # 作成者が current_user になる
      expect(Article.find(json['id']).user_id).to eq(user.id)
    end

    it 'status: published で作成できる（201）' do
      params = { article: { title: 'T2', body: 'B2', status: 'published' } }
      post '/api/v1/articles', params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json['status']).to eq('published')
      expect(Article.find(json['id']).user_id).to eq(user.id)
    end
  end

  context '認証なし' do
    it '401 を返す' do
      params = { article: { title: 'T', body: 'B', status: 'draft' } }
      post '/api/v1/articles', params: params, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
