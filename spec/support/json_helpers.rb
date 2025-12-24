module JsonHelpers
  # テストのレスポンス本文をJSONとして扱う小ヘルパー
  def json(symbolize: false)
    body = response.body
    return {} if body.blank?
    JSON.parse(body, symbolize_names: symbolize)
  end
end
