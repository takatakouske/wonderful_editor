module Api
  module V1
    class ArticlePreviewSerializer < ActiveModel::Serializer
      attributes :id, :title, :updated_at

      # body は含めない（一覧はプレビュー）
      # updated_at は ISO8601 文字列に整形して返す
      def updated_at
        object.updated_at.iso8601
      end
    end
  end
end
