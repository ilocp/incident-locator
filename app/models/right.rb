# == Schema Information
#
# Table name: rights
#
#  id         :integer          not null, primary key
#  resource   :string(255)
#  operation  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Right < ActiveRecord::Base
  attr_accessible :operation, :resource

  has_many :grants
  has_many :roles, :through => :grants

  # map all available controller actions to CRUD operations
  OPERATION_MAPPINGS = {
    new:      'CREATE',
    create:   'CREATE',
    edit:     'UPDATE',
    update:   'UPDATE',
    destroy:  'DELETE',
    show:     'READ',
    index:    'READ',
    map:      'READ'
  }
end
