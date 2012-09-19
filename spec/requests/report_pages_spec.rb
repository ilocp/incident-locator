require 'spec_helper'

describe "Report pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:submit) { 'Create report' }
  before { sign_in user }

  describe "report creation" do
    before { visit new_report_path }

    describe "with invalid data" do
      it "should not create new report" do
        expect { click_button submit }.not_to change(Report, :count)
      end

      describe "should show error messages" do
        before { click_button submit }
        it { should have_content('error') }
      end
    end

    describe "with valid data" do
      before do
        fill_in "Latitude", with: 23.0924581
        fill_in "Longitude", with: 114.2130987
        fill_in "Heading", with: 234
      end

      it "should create new report" do
        expect { click_button submit }.to change(Report, :count).by(1)
      end

      describe "after submition" do
        before { click_button submit }

        it { should have_success_msg('successfully') }
      end
    end
  end

  describe "incident creation" do
    before { visit new_report_path }

    describe "with two new valid reports on the same area" do

      # 1st report from factory
      let!(:report1) do
        FactoryGirl.create(:report, user: user, latitude: 37.980443,
                           longitude: 23.6691, heading: 90)
      end

      # second report (through web)
      before do
        fill_in "Latitude", with: 37.978802
        fill_in "Longitude", with: 23.670881
        fill_in "Heading", with: 65
      end

      it "should create a new incident with proper ids" do
        expect { click_button submit }.to change(Report, :count).by(1)
        incident = Incident.last
        Report.where(incident_id: incident.id).count.should == 2
      end
    end
  end
end
