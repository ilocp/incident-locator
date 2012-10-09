# == Schema Information
#
# Table name: incidents
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  radius     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_incidents_on_latitude_and_longitude  (latitude,longitude)
#

class Incident < ActiveRecord::Base
  include FormatCoordinates

  attr_accessible :longitude, :latitude, :radius

  has_many :reports

  before_save :round_coordinates

  acts_as_gmappable :process_geocoding => false

  validates :latitude, presence: true, numericality: true, latitude: true
  validates :longitude, presence: true, numericality: true, longitude: true
  validates :radius, presence: true, numericality: { greater_than: 0 }

end
