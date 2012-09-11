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

  LAT_RANGE = -90..90
  LNG_RANGE = -180..180

  validates :latitude, presence: true, numericality: true, inclusion: { in: LAT_RANGE }
  validates :longitude, presence: true, numericality: true, inclusion: { in: LNG_RANGE }
  validates :radius, presence: true, numericality: { greater_than: 0 }

end
