# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Role do
  before { @role = Role.new(name: 'role1') }
  subject { @role }

  it { should respond_to :name }

  # associations
  it { should respond_to :rights }

  it { should be_valid }

  describe "with empty name" do
    before { @role.name = nil }
    it { should_not be_valid }
  end

  describe "with duplicate name" do
    before { @role.save }

    describe "with same case" do
      before { @role2 = Role.new(name: @role.name) }
      it { @role2.should_not be_valid }
    end

    describe "with different case" do
      before { @role2 = Role.new(name: @role.name.swapcase) }
      it { @role2.should_not be_valid }
    end
  end
end
