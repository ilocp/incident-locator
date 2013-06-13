class AddIncidentFieldsRequiredForStaticIncidentEngine < ActiveRecord::Migration
  class Incident < ActiveRecord::Base
  end

  def change
    add_column :incidents, :avg_lat, :float
    add_column :incidents, :avg_lng, :float
    add_column :incidents, :std_dev, :float

    migration_data = { avg_lat: 0.0, avg_lng: 0.0, std_dev: 0.0 }
    migration_opts = { without_protection: true }
    Incident.reset_column_information
    Incident.all.each do |i|
      i.update_attributes!(migration_data, migration_opts)
    end
  end
end
