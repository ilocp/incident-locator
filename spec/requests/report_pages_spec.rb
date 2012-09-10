require 'spec_helper'

describe "Report pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "report creation" do
    before { visit new_report_path }
    let(:submit) { 'Create report' }

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
end
