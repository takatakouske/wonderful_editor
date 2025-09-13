class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :user,    null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.timestamps
    end
    add_index :comments, [:article_id, :created_at]
  end
end
