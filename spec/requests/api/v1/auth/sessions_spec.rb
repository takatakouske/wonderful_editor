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
    it 'サインアウトでき 200 OK を返し、そのトークンは以後無効（401）になる' do
      # まずログインしてトークン取得
      post '/api/v1/auth/sign_in', params: { email: user.email, password: 'password' }, as: :json
      auth_headers = {
        'access-token' => response.headers['access-token'],
        'client'       => response.headers['client'],
        'uid'          => response.headers['uid']
      }

      # sign_out
      delete '/api/v1/auth/sign_out', headers: auth_headers
      expect(response).to have_http_status(:ok)

      # 同じトークンで validate すると 401（無効化確認）
      get '/api/v1/auth/validate_token', headers: auth_headers
      expect(response).to have_http_status(:unauthorized)
    end

    it '無効なトークンだと 404 Not Found を返す' do
      bad_headers = {
        'uid'          => user.uid,
        'client'       => 'bogus',
        'access-token' => 'bogus'
      }
      delete '/api/v1/auth/sign_out', headers: bad_headers
      expect(response.status).to eq(404) # devise_token_auth の既定挙動
    end

    it '複数クライアントの一方だけを無効化できる' do
      # クライアント1でログイン
      post '/api/v1/auth/sign_in', params: { email: user.email, password: 'password' }, as: :json
      headers1 = {
        'access-token' => response.headers['access-token'],
        'client'       => response.headers['client'],
        'uid'          => response.headers['uid']
      }

      # クライアント2でもう一度ログイン
      post '/api/v1/auth/sign_in', params: { email: user.email, password: 'password' }, as: :json
      headers2 = {
        'access-token' => response.headers['access-token'],
        'client'       => response.headers['client'],
        'uid'          => response.headers['uid']
      }

      # クライアント1だけ sign_out
      delete '/api/v1/auth/sign_out', headers: headers1
      expect(response).to have_http_status(:ok)

      # headers1 は無効（401）
      get '/api/v1/auth/validate_token', headers: headers1
      expect(response).to have_http_status(:unauthorized)

      # headers2 はまだ有効（200）
      get '/api/v1/auth/validate_token', headers: headers2
      expect(response).to have_http_status(:ok)
    end
  end
end
