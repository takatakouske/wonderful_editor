require 'rails_helper'

RSpec.describe 'API::V1::Articles#index', type: :request do
  let!(:user) { User.create!(email: 'u1@example.com', name: 'U1', password: 'password', password_confirmation: 'password') }
  let!(:published_article) { Article.create!(title: 'Pub',  body: 'B', user: user, status: :published) }
  let!(:draft_article)     { Article.create!(title: 'Draft', body: 'B', user: user, status: :draft) }

  it '公開記事のみ返す（draftは含まれない）' do
    get '/api/v1/articles'
    expect(response).to have_http_status(:ok)

    ids = json.map { |h| h['id'] }
    expect(ids).to include(published_article.id)
    expect(ids).not_to include(draft_article.id)
  end
end
