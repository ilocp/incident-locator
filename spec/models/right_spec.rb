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

require 'spec_helper'

describe Right do
  before { @right = Right.new(resource: 'users', operation: 'READ') }
  subject { @right}

  it { should respond_to :resource }
  it { should respond_to :operation }

  # associations
  it { should respond_to :roles }

  it { should be_valid }

  describe "with empty resource" do
    before { @right.resource = nil }
    it { should_not be_valid }
  end

  describe "with empty operation" do
    before { @right.operation = nil }
    it { should_not be_valid }
  end

  describe "with multiple entries" do
    before { @right.save }

    describe "with duplicate resource-operation combination" do
      before { @right2 = @right.dup }
      it { @right2.should_not be_valid }
    end

    describe "with different resource-operation combinatio" do
      before do
        @right2 = @right.dup
        @right2.resource = :incidents
      end
      it { @right2.should be_valid }
    end
  end
end
