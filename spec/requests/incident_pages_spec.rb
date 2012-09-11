require 'spec_helper'

describe "Incident pages" do
  subject { page }

  describe "index" do
    let!(:incident) { FactoryGirl.create(:incident) }
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit incidents_path
    end

    it { should have_h1('Incidents') }
    it { should have_selector('div.incidents table') }
    it { should have_content(incident.latitude) }
    it { should have_content(incident.longitude) }
    it { should have_content(incident.radius) }
  end
end
