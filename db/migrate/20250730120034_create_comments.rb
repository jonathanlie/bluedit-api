class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.references :parent_comment, null: true, foreign_key: { to_table: :comments }, type: :uuid

      t.timestamps
    end
  end
end
