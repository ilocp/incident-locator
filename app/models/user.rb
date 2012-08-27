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

class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :name, :email, :password, :password_confirmation

  # basic email regex
  RE_EMAIL = /\A[\w\-\.\+]+@[a-z\d\-\.]+[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: RE_EMAIL },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :password_confirmation, presence: true

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
