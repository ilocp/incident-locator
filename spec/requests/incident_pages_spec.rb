require 'spec_helper'

describe "Incident pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  describe "index" do
    let!(:incident) { FactoryGirl.create(:incident) }

    before do
      sign_in user
      visit incidents_path
    end

    it { should have_h1('Incidents') }
    it { should have_selector('div.incidents table') }
    it { should have_content(incident.latitude) }
    it { should have_content(incident.longitude) }
    it { should have_content(incident.radius) }
    it { should have_content(incident.reports.size) }
    it { should have_link(incident.reports.size,
                          href: map_report_path(incident.id)) }
  end

  describe "map" do
    before do
      sign_in user
      visit map_path
    end

    it { should have_selector('div.map_container div#map') }
  end
end
