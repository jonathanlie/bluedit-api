class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :votable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
