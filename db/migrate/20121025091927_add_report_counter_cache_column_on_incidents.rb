class AddReportCounterCacheColumnOnIncidents < ActiveRecord::Migration
  def up
    add_column :incidents, :reports_count, :integer, :default => 0

    Incident.reset_column_information
    Incident.all.each do |i|
      Incident.update_counters i.id, :reports_count => i.reports.length
    end
  end

  def down
    remove_column :incidents, :reports_count
  end
end
