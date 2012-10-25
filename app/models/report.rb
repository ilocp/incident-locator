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

  validates :user_id, presence: true
  validates :latitude, presence: true, numericality: true, latitude: true
  validates :longitude, presence: true, numericality: true, longitude: true
  validates :heading, presence: true, heading: true,
            numericality: { only_integer: true, message: "must be an integer value" }

  default_scope order: 'reports.created_at DESC'

end
