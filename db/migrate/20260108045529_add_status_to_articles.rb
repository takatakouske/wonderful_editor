class AddStatusToArticles < ActiveRecord::Migration[6.1]
  def up
    add_column :articles, :status, :integer, null: false, default: 0
    # 既存データの安全確保（万一 default が反映されないDBでも念のため）
    Article.reset_column_information
    Article.where(status: nil).update_all(status: 0)
  end

  def down
    remove_column :articles, :status
  end
end
