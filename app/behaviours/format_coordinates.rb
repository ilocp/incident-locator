#
# Defines common location callbacks for models
#

module FormatCoordinates

    def round_coordinates
      # round lat/lng to 7 decimal digits (cm precision)
      self.latitude = self.latitude.round(7)
      self.longitude = self.longitude.round(7)
    end

end
