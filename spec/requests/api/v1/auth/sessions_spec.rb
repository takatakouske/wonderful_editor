# spec/requests/api/v1/auth/sessions_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Auth::Sessions', type: :request do
  let!(:user) do
    User.create!(
      email: 'user1@example.com',
      name:  'User One',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  describe 'POST /api/v1/auth/sign_in' do
    context '有効な資格情報のとき' do
      it '200 OK とトークン系ヘッダを返す' do
        post '/api/v1/auth/sign_in', params: { email: user.email, password: 'password' }, as: :json
        expect(response).to have_http_status(:ok)

        # devise_token_auth のトークン系ヘッダ
        expect(response.headers['access-token']).to be_present
        expect(response.headers['client']).to be_present
        expect(response.headers['uid']).to eq(user.uid)

        body = json
        expect(body.dig('data','email')).to eq(user.email)
      end
    end

    context 'パスワードが不正なとき' do
      it '401 Unauthorized を返す' do
        post '/api/v1/auth/sign_in', params: { email: user.email, password: 'wrong' }, as: :json
        expect(response).to have_http_status(:unauthorized)
        # 可能ならエラーメッセージの検証も
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    it 'サインアウトでき 200 OK を返す' do
      # まずログイン
      post '/api/v1/auth/sign_in', params: { email: user.email, password: 'password' }, as: :json
      auth_headers = {
        'access-token' => response.headers['access-token'],
        'client'       => response.headers['client'],
        'uid'          => response.headers['uid']
      }

      delete '/api/v1/auth/sign_out', headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
