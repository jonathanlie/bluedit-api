class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :subbluedit, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
