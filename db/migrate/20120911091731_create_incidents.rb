class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.float :latitude
      t.float :longitude
      t.float :radius

      t.timestamps
    end
  end
end
