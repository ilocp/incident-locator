# Validate fields used to store compass heading in degrees
# Compass heading must be between 0 and 360 degrees
#
# Note: We still need the numericality validation

class HeadingValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless (0..360).include?(value)
      record.errors[attribute] << (options[:message] || 'value must be betweeb 0 and 360 degrees')
    end
  end
end
