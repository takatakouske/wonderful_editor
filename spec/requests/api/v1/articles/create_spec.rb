require 'rails_helper'

RSpec.describe "Api::V1::Articles#create", type: :request do
  let(:user) { create(:user) }

  before do
    # ★ スタブ：テスト時だけ current_user を任意のユーザーに差し替える
    allow_any_instance_of(Api::V1::BaseApiController)
      .to receive(:current_user).and_return(user)

    # 念のため、認証フィルタも no-op に（current_user を見る実装なら不要ですが安全策）
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
    data = json["article"] || json  # AMS :json なら "article"、未設定なら直ハッシュ

    expect(data["title"]).to eq("new title")
    # DB の所有者が stub した user になっていること
    expect(Article.last.user_id).to eq(user.id)
  end

  it "returns 422 when params are invalid" do
    post "/api/v1/articles", params: { article: { title: "", body: "" } }

    expect(response).to have_http_status(:unprocessable_entity)

    json = JSON.parse(response.body)
    # render_unprocessable! が { errors: [...] } を返す想定
    expect(json["errors"]).to be_present
  end
end
