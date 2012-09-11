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

class Incident < ActiveRecord::Base
  attr_accessible :longitude, :latitude, :radius

  has_many :reports

  validates :latitude, presence: true, numericality: true, latitude: true
  validates :longitude, presence: true, numericality: true, longitude: true
  validates :radius, presence: true, numericality: { greater_than: 0 }

end
