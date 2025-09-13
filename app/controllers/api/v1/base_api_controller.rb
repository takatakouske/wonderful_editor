module Api
  module V1
    class BaseApiController < Api::BaseController
      # v1では原則認証必須（公開エンドポイントだけ各Controllerでskip）
      before_action :authenticate_user!

      # v1だけの共通ポリシーやフィルタをここに追加
      # 例）ヘッダの互換性チェック、v1固定のシリアライザ設定 等
    end
  end
end
