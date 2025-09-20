module Api
  module V1
    class ArticleDetailSerializer < ActiveModel::Serializer
      attributes :id, :title, :body, :updated_at

      # フロントは更新日ベースで表示するので updated_at を返す（ISO8601）
      def updated_at
        object.updated_at.iso8601
      end
    end
  end
end
