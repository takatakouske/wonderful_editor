require 'rails_helper'

RSpec.describe "Api::V1::Articles#show", type: :request do
  it "is public and returns detail with body; date is based on updated_at" do
    article = create(:article, title: "title", body: "content", updated_at: Time.current)

    # 認証なし（公開）
    get "/api/v1/articles/#{article.id}"

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)
    data = json["article"] || json  # adapter :json なら "article"

    expect(data["id"]).to eq(article.id)
    expect(data["title"]).to eq("title")
    expect(data["body"]).to eq("content")
    expect(data["updated_at"]).to match(/\d{4}-\d{2}-\d{2}T/)
  end

  it "returns 404 when article not found" do
    get "/api/v1/articles/999_999_999"
    expect(response).to have_http_status(:not_found)
  end
end
