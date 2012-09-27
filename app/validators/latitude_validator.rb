# Validate fields used to store latitude values
# Longitude values should be between -90 and 90
#
# Note: We still need the numericality validation

class LatitudeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless (-90..90).include?(value)
      record.errors[attribute] << (options[:message] || 'value must be between -90 and 90')
    end
  end
end
