# == Schema Information
#
# Table name: incidents
#
#  id            :integer          not null, primary key
#  latitude      :float
#  longitude     :float
#  radius        :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  reports_count :integer          default(0)
#  avg_lat       :float
#  avg_lng       :float
#  std_dev       :float
#
# Indexes
#
#  index_incidents_on_latitude_and_longitude  (latitude,longitude)
#

class Incident < ActiveRecord::Base
  include FormatCoordinates

  attr_accessible :longitude, :latitude, :radius, :avg_lat, :avg_lng, :std_dev

  has_many :reports

  before_save :round_coordinates
  after_initialize :default_avg_data

  acts_as_gmappable :process_geocoding => false

  validates :latitude, presence: true, numericality: true, latitude: true
  validates :longitude, presence: true, numericality: true, longitude: true
  validates :radius, presence: true, numericality: { greater_than: 0 }
  validates :avg_lat, numericality: true, latitude: true
  validates :avg_lng, numericality: true, longitude: true
  validates :std_dev, numericality: true

  default_scope order: 'incidents.updated_at DESC'

  private
    def default_avg_data
      self.avg_lat ||= 0.0
      self.avg_lng ||= 0.0
      self.std_dev ||= 0.0
    end
end
