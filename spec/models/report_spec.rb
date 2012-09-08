# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  latitude    :float
#  longitude   :float
#  heading     :integer
#  incident_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#

require 'spec_helper'

describe Report do
  let(:user) { FactoryGirl.create(:user) }
  before { @report = user.reports.build(latitude: 10.123456, longitude: 10.123456,
                                       heading: 200) }
  subject { @report }

  it { should respond_to :latitude }
  it { should respond_to :longitude }
  it { should respond_to :heading }
  it { should respond_to :user_id }
  it { should respond_to :incident_id }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Report.new(user_id: user.id)
      end.to raise_error ActiveModel::MassAssignmentSecurity::Error
    end
  end
end
