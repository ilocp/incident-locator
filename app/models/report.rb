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

  COORDINATES_RANGE = -180..180
  HEADING_RANGE = 0..360

  validates :user_id, presence: true
  validates :latitude, presence: true, inclusion: { in: COORDINATES_RANGE }
  validates :longitude, presence: true, inclusion: { in: COORDINATES_RANGE }
  validates :heading, presence: true, numericality: { only_integer: true },
            inclusion: { in: HEADING_RANGE }
end
