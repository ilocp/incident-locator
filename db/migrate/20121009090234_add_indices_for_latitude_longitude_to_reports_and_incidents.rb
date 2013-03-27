class AddIndicesForLatitudeLongitudeToReportsAndIncidents < ActiveRecord::Migration
  def change
    # for reports table
    add_index :reports, [:latitude, :longitude]

    # for incidents table
    add_index :incidents, [:latitude, :longitude]
  end
end
