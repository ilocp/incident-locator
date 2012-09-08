class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.float :latitude
      t.float :longitude
      t.integer :heading
      t.integer :incident_id

      t.timestamps
    end
    add_index :reports, :user_id
  end
end
