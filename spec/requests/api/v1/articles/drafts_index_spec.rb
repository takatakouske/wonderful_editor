require 'rails_helper'

RSpec.describe 'API::V1::Articles::Drafts#index', type: :request do
  let!(:me)      { User.create!(email: 'me@example.com',  name: 'Me',  password: 'password', password_confirmation: 'password') }
  let!(:other)   { User.create!(email: 'you@example.com', name: 'You', password: 'password', password_confirmation: 'password') }

  let!(:my_d1)   { Article.create!(title: 'D1', body: 'B', user: me,    status: :draft) }
  let!(:my_p1)   { Article.create!(title: 'P1', body: 'B', user: me,    status: :published) }
  let!(:your_d1) { Article.create!(title: 'OD', body: 'B', user: other, status: :draft) }

  let(:auth_headers) { me.create_new_auth_token }

  context '認証あり' do
    it '自分の下書きのみ返す（他人の下書きや自分の公開は含まない）' do
      get '/api/v1/articles/drafts', headers: auth_headers
      expect(response).to have_http_status(:ok)

      ids = JSON.parse(response.body).map { |h| h['id'] }
      expect(ids).to include(my_d1.id)
      expect(ids).not_to include(my_p1.id)
      expect(ids).not_to include(your_d1.id)
    end
  end

  context '認証なし' do
    it '401 を返す' do
      get '/api/v1/articles/drafts'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
