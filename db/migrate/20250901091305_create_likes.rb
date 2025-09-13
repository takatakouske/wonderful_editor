class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.timestamps
    end
    # 同じユーザーが同じ記事を二重いいねできないように
    add_index :likes, [:user_id, :article_id], unique: true
  end
end
