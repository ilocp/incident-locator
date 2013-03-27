# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  latitude    :float
#  longitude   :float
#  heading     :integer
#  incident_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reports_on_latitude_and_longitude  (latitude,longitude)
#  index_reports_on_user_id                 (user_id)
#

class Report < ActiveRecord::Base
  include FormatCoordinates

  attr_accessible :latitude, :longitude, :heading

  belongs_to :user
  belongs_to :incident, :counter_cache => true

  before_save :round_coordinates
  after_save :update_report_counters_on_incident, :if => :incident_id_changed?

  validates :user_id, presence: true
  validates :latitude, presence: true, numericality: true, latitude: true
  validates :longitude, presence: true, numericality: true, longitude: true
  validates :heading, presence: true, heading: true,
            numericality: { only_integer: true, message: "must be an integer value" }

  default_scope order: 'reports.created_at DESC'

  private

  def update_report_counters_on_incident
    # check if new incident_id is nil
    # this avoids a pointles UPDATE query with incident.id NULL
    # this can happend if we completely unassign a report
    unless self.incident.nil?
      Incident.increment_counter(:reports_count, self.incident_id)
    end

    # if incident_id changed and was not nil we need to decrement
    # the previous counter (report reparenting)
    unless self.incident_id_was.nil?
      Incident.decrement_counter(:reports_count, self.incident_id_was)
    end
  end

end
