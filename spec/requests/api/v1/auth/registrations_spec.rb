require 'rails_helper'

RSpec.describe "API::V1::Auth::Registrations", type: :request do
  let(:path) { "/api/v1/auth" }
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT"       => "application/json"
    }
  end

  describe "POST #{"/api/v1/auth"} (sign up)" do
    context "有効なパラメータのとき" do
      let(:email) { "tester_#{SecureRandom.hex(4)}@example.com" }
      let(:params) do
        {
          email: email,
          password: "password123",
          password_confirmation: "password123",
          name: "Tester"
        }
      end

      it "ユーザーが作成され、トークン系ヘッダが返る（200 OK）" do
        expect {
          post path, params: params.to_json, headers: headers
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)

        # DeviseTokenAuth の必須レスポンスヘッダを確認
        %w[access-token client uid token-type expiry].each do |k|
          expect(response.headers[k]).to be_present
        end

        # レスポンスJSONの中身（最低限の確認）
        body = json
        expect(body).to be_a(Hash)
        expect(body["data"]).to be_present
        expect(body["data"]["email"]).to eq(email)

        # DBに保存されたユーザーの属性確認（任意）
        user = User.find_by(email: email)
        expect(user).to be_present
        expect(user.name).to eq("Tester")
      end
    end

    context "password_confirmation が不一致のとき" do
      let(:params) do
        {
          email: "mismatch@example.com",
          password: "password123",
          password_confirmation: "password999",
          name: "Mismatch"
        }
      end

      it "422 Unprocessable Entity が返り、errors を含む" do
        post path, params: params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        body = json
        expect(body).to be_a(Hash)
        # DTAは errors を返す。キー名は環境により異なることがあるが一般に "errors"
        expect(body["errors"]).to be_present
      end
    end

    context "同一メールが既に存在するとき" do
      let(:email) { "dup@example.com" }

      before do
        User.create!(email: email, password: "password123", password_confirmation: "password123", name: "Dup")
      end

      it "422 Unprocessable Entity" do
        post path,
             params: {
               email: email,
               password: "password123",
               password_confirmation: "password123",
               name: "Dup2"
             }.to_json,
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        body = json
        expect(body["errors"]).to be_present
      end
    end
  end
end
