class AddIndicesToAuthorizationTables < ActiveRecord::Migration
  def change
    add_index :grants, [:right_id, :role_id]
    add_index :assignments, [:user_id, :role_id]
  end
end
