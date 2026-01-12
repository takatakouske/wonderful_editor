require 'rails_helper'

RSpec.describe 'API::V1::Current::Articles#index', type: :request do
  let!(:me)    { User.create!(email: 'me@example.com',  name: 'Me',  password: 'password', password_confirmation: 'password') }
  let!(:other) { User.create!(email: 'you@example.com', name: 'You', password: 'password', password_confirmation: 'password') }

  let!(:my_pub)     { Article.create!(title: 'my pub',  body: 'b', user: me,    status: :published) }
  let!(:my_draft)   { Article.create!(title: 'my dr',   body: 'b', user: me,    status: :draft) }
  let!(:oth_pub)    { Article.create!(title: 'oth pub', body: 'b', user: other, status: :published) }
  let!(:oth_draft)  { Article.create!(title: 'oth dr',  body: 'b', user: other, status: :draft) }

  let(:auth_headers) { me.create_new_auth_token }

  context '認証あり' do
    it '自分の公開記事のみ返す（自分の下書き・他人の公開/下書きは含まない）' do
      get '/api/v1/current/articles', headers: auth_headers
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      ids  = body.map { |a| a['id'] }

      expect(ids).to include(my_pub.id)
      expect(ids).not_to include(my_draft.id)
      expect(ids).not_to include(oth_pub.id)
      expect(ids).not_to include(oth_draft.id)
    end
  end

  context '認証なし' do
    it '401 を返す' do
      get '/api/v1/current/articles'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
