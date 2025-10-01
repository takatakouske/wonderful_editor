require 'rails_helper'

RSpec.describe "Api::V1::Articles#update", type: :request do
  let(:owner)      { create(:user) }
  let(:other_user) { create(:user) }
  let(:article)    { create(:article, user: owner, title: "old title", body: "old body") }

  context "when signed in as the owner" do
    before do
      allow_any_instance_of(Api::V1::BaseApiController)
        .to receive(:current_user).and_return(owner)
    end

    it "updates and returns 200 with the updated article" do
      params = { article: { title: "new title", body: "new body" } }

      patch "/api/v1/articles/#{article.id}", params: params
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      data = json["article"] || json
      expect(data["title"]).to eq("new title")
      expect(data["body"]).to  eq("new body")

      article.reload
      expect(article.title).to eq("new title")
      expect(article.body).to  eq("new body")
      expect(article.user_id).to eq(owner.id) # 所有者は変わらない
    end

    it "returns 422 when params are invalid and does not update" do
      patch "/api/v1/articles/#{article.id}", params: { article: { title: "", body: "" } }
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present

      article.reload
      expect(article.title).to eq("old title")
      expect(article.body).to  eq("old body")
    end
  end

  context "when signed in as another user" do
    before do
      allow_any_instance_of(Api::V1::BaseApiController)
        .to receive(:current_user).and_return(other_user)
    end

    it "returns 403 and does not update" do
      patch "/api/v1/articles/#{article.id}", params: { article: { title: "hack" } }
      expect(response).to have_http_status(:forbidden)

      article.reload
      expect(article.title).to eq("old title")
    end
  end

  context "when unauthenticated" do
  before do
    # ★ 仮フォールバック(User.first)を無効化して確実に未ログインにする
    allow_any_instance_of(Api::V1::BaseApiController)
      .to receive(:current_user).and_return(nil)
  end

  it "returns 401" do
    patch "/api/v1/articles/#{article.id}", params: { article: { title: "nope" } }
    expect(response).to have_http_status(:unauthorized)
  end
end

  it "returns 404 when article not found" do
    allow_any_instance_of(Api::V1::BaseApiController)
      .to receive(:current_user).and_return(owner)

    patch "/api/v1/articles/999_999_999", params: { article: { title: "x" } }
    expect(response).to have_http_status(:not_found)
  end
end
