require 'rails_helper'

RSpec.describe 'API::V1::Articles#show', type: :request do
  let!(:user) { User.create!(email: 'u1@example.com', name: 'U1', password: 'password', password_confirmation: 'password') }
  let!(:published_article) { Article.create!(title: 'Pub',  body: 'B', user: user, status: :published) }
  let!(:draft_article)     { Article.create!(title: 'Draft', body: 'B', user: user, status: :draft) }

  it '公開記事は 200 OK を返す' do
    get "/api/v1/articles/#{published_article.id}"
    expect(response).to have_http_status(:ok)
    expect(json['id']).to eq(published_article.id)
  end

  it '下書き記事は 404 を返す' do
    get "/api/v1/articles/#{draft_article.id}"
    expect(response).to have_http_status(:not_found)
  end
end
