# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string(255)
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base

  has_secure_password

  attr_accessible :name, :email, :password, :password_confirmation

  has_many :reports, dependent: :destroy

  # authorization associations
  has_many :assignments
  has_many :roles, :through => :assignments

  # we need to be consistent as we use an index on email column
  before_save { |user| user.email = email.downcase }

  # basic email regex
  RE_EMAIL = /\A[\w\-\.\+]+@[a-z\d\-\.]+[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: RE_EMAIL },
            uniqueness: { case_sensitive: false }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, length: { minimum: 6 }

  def can?(resource, action)
    roles.includes(:rights).for(resource, action).any?
  end
end
