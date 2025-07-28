class CreateSubbluedits < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :subbluedits, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end
    add_index :subbluedits, :name, unique: true
  end
end
