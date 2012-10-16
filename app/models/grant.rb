# == Schema Information
#
# Table name: grants
#
#  id         :integer          not null, primary key
#  right_id   :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Grant < ActiveRecord::Base
  attr_accessible :right_id, :role_id

  belongs_to :role
  belongs_to :right

end
