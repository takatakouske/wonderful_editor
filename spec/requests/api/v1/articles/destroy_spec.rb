require 'rails_helper'

RSpec.describe "Api::V1::Articles#destroy", type: :request do
  let(:owner)      { create(:user) }
  let(:other_user) { create(:user) }
  let!(:article)   { create(:article, user: owner) }

  context "when signed in as the owner" do
    before do
      allow_any_instance_of(Api::V1::BaseApiController)
        .to receive(:current_user).and_return(owner)
    end

    it "deletes the article and returns 204 No Content" do
      expect {
        delete "/api/v1/articles/#{article.id}"
      }.to change(Article, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_blank
    end
  end

  context "when signed in as another user" do
    before do
      allow_any_instance_of(Api::V1::BaseApiController)
        .to receive(:current_user).and_return(other_user)
    end

    it "returns 403 and does not delete" do
      expect {
        delete "/api/v1/articles/#{article.id}"
      }.not_to change(Article, :count)

      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when unauthenticated" do
    before do
      # dev/test の仮フォールバック(User.first)を打ち消し、確実に未ログインにする
      allow_any_instance_of(Api::V1::BaseApiController)
        .to receive(:current_user).and_return(nil)
    end

    it "returns 401 and does not delete" do
      expect {
        delete "/api/v1/articles/#{article.id}"
      }.not_to change(Article, :count)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  it "returns 404 when article not found" do
    allow_any_instance_of(Api::V1::BaseApiController)
      .to receive(:current_user).and_return(owner)

    expect {
      delete "/api/v1/articles/999_999_999"
    }.not_to change(Article, :count)

    expect(response).to have_http_status(:not_found)
  end
end

