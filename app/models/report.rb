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
#  index_reports_on_user_id  (user_id)
#

class Report < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :heading

  belongs_to :user

  before_save :round_coordinates

  LAT_RANGE = -90..90
  LNG_RANGE = -180..180
  HEADING_RANGE = 0..360

  validates :user_id, presence: true
  validates :latitude, presence: true, inclusion: { in: LAT_RANGE,
            message: "values must be between -90 and 90" }
  validates :longitude, presence: true, inclusion: { in: LNG_RANGE,
            message: "values must be between -180 and 180" }
  validates :heading, presence: true,
            numericality: { only_integer: true, message: "must be an integer value" },
            inclusion: { in: HEADING_RANGE, message: "values must be between 0 and 369" }

  default_scope order: 'reports.created_at DESC'

  private

    def round_coordinates
      # round lat/lng to 7 decimal digits (cm precision)
      self.latitude = self.latitude.round(7)
      self.longitude = self.longitude.round(7)
    end
end
