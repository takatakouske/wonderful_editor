require 'rails_helper'

RSpec.describe "Api::V1::Articles#create", type: :request do
  let(:user) { create(:user) }

  before do
    # ★ テスト時だけ current_user を差し替える（スタブ）
    allow_any_instance_of(Api::V1::BaseApiController)
      .to receive(:current_user).and_return(user)

    # 認証フィルタで止まらないように（必要に応じて）
    allow_any_instance_of(Api::V1::BaseApiController)
      .to receive(:authenticate_user!).and_return(true)
  end

  it "creates an article owned by current_user" do
    params = { article: { title: "new title", body: "new body" } }

    expect {
      post "/api/v1/articles", params: params
    }.to change(Article, :count).by(1)

    expect(response).to have_http_status(:created)

    json = JSON.parse(response.body)
    data = json["article"] || json  # AMS adapter :json なら "article"

    expect(data["title"]).to eq("new title")
    expect(Article.last.user_id).to eq(user.id)   # 所有者が current_user
  end

  it "returns 422 with errors for invalid params" do
    post "/api/v1/articles", params: { article: { title: "", body: "" } }
    expect(response).to have_http_status(:unprocessable_entity)

    json = JSON.parse(response.body)
    expect(json["errors"]).to be_present
  end
end
