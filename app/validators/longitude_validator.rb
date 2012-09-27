# Validate fields used to store longitude values
# Longitude values should be between -180 and 180
#
# Note: We still need the numericality validation

class LongitudeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless (-180..180).include?(value)
      record.errors[attribute] << (options[:message] || 'value must be betweeb -180 and 180')
    end
  end
end
