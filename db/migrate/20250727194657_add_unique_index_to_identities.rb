class AddUniqueIndexToIdentities < ActiveRecord::Migration[8.0]
  def change
    add_index :identities, [:user_id, :provider], unique: true
  end
end
