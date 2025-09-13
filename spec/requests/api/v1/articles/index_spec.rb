# spec/requests/api/v1/articles/index_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Articles#index", type: :request do
  before do
    # 並びの検証用に updated_at を明示
    @old    = create(:article, title: "old",    updated_at: 2.days.ago)
    @middle = create(:article, title: "middle", updated_at: 1.day.ago)
    @new    = create(:article, title: "new",    updated_at: Time.current)
  end

  it "is public and returns previews without body ordered by updated_at desc" do
    # 一覧は誰でも見られる前提（controllerで authenticate_user! を skip 済み）
    get "/api/v1/articles"

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    # AMS adapter を :json にしていれば { "articles": [...] } になる
    list = json["articles"] || json # 念のため配列直返しにも対応

    expect(list).to be_an(Array)

    # 1) 本文は含めない（body キー無し）
    expect(list.first).not_to have_key("body")

    # 2) updated_at の降順（new → middle → old）
    expect(list.map { |h| h["title"] }).to eq(%w[new middle old])

    # 3) updated_at は ISO8601 文字列
    expect(list.first["updated_at"]).to match(/\d{4}-\d{2}-\d{2}T/)
  end
end
