# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  attr_accessible :name

  has_many :assignments
  has_many :grants

  has_many :users, :through => :assignments
  has_many :rights, :through => :grants

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :for, lambda { |resource, action|
    where("rights.operation = ? AND rights.resource = ?",
          Right::OPERATION_MAPPINGS[action], resource
    )
  }

  # define scopes for each role
  scope :admin, where(name: 'Admin')
  scope :viewer, where(name: 'Viewer')
  scope :reporter, where(name: 'Reporter')
end
