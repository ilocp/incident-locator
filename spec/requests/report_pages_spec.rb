require 'spec_helper'

describe "Report pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:reporter) }
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

  # this test needs at least 2 reports assigned to the incident
  # else the detector algorithm will fail because we use the report
  # number as an adjustment weight
  describe "report attachment to incident" do
    let(:incident) { FactoryGirl.create(:incident, latitude: 38.0388329,
                                        longitude: 24.3521278, radius: 3000.0) }
    let(:report1) { FactoryGirl.create(:report, user: user) }
    let(:report2) { FactoryGirl.create(:report, user: user) }

    before do
      incident.reports << report1
      incident.reports << report2
    end

    describe "incident location adjustment" do
      before do
        visit new_report_path
        fill_in "Latitude", with: 38.044540
        fill_in "Longitude", with: 24.353771
        fill_in "Heading", with: 120
        click_button submit
      end

      it "should adjust the incident location" do
        adj_incident = Incident.find_by_id incident.id
        expect(adj_incident.latitude).not_to eq(incident.latitude)
        expect(adj_incident.longitude).not_to eq(incident.longitude)
      end
    end
  end
end
