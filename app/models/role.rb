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

  # class methods for roles so we can access them fast
  # * Role.admin
  # * Role.viewer
  # * Role.reporter

  def self.admin
    where(name: 'Admin').first
  end

  def self.reporter
    where(name: 'Reporter').first
  end

  def self.viewer
    where(name: 'Viewer').first
  end
end
