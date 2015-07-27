require 'rails_helper'
require 'net/http'
# require 'json'
RSpec.describe ReportsController do
  let(:report) { create(:report) }
  let(:user) { create(:user) }
  let(:term) { create(:term) }
  describe 'GET show' do
    it 'requires authentication' do
      get :show, report: report, id: report.name
      expect(response.status).to eq(401)
    end
    it 'assigns a report' do
      get :show, id: report.name
      expect(assigns(:report)).to eq(report)
    end
    it 'assigns all terms' do
      establish_current_user(user)
      get :show, id: report.name
      term = create(:term)
      termtwo = create(:term, name: 'Academic Year')
      expect(assigns(:terms)).to include(term, termtwo)
    end
    it 'grabs a photo for a report with timestamp' do
      establish_current_user(user)
      @report = Report.create(name: 'my term', timestamp: 123456789)
      get :show, id: @report.name
      expect(assigns(:report_photo).image_url).to include('123456789')
    end
  end
  describe 'PUT update' do
    it 'requires authentication' do
      put :update, report: report, id: report.name
      expect(response.status).to eq(401)
    end
    it 'located the requested report' do
      put :update, id: report.name, report: attributes_for(:report)
      expect(assigns(:report)).to eq(report)
    end
    it 'updates a report in the database' do
      establish_current_user(user)
      @report = create(:report)
      expect(@report.name).to_not eq('My Report')
      expect(@report.description).to_not eq('Super Dooper')
      my_changed_report = attributes_for(
        :report, name: 'My Report', description: 'Super Dooper')
      put :update, id: @report.name, report: my_changed_report
      @report.reload
      expect(@report.name).to eq('My Report')
      expect(@report.description).to eq('Super Dooper')
      expect(assigns(:report).name).to eq('My Report')
    end
    it 'updates terms association' do
      establish_current_user(user)
      @report = create(:report)
      @term = Term.create(name: 'my term')
      @term2 = Term.create(name: 'your term')
      my_changed_report = attributes_for(
        :report, name: 'My Report', terms: [@term.name, @term2.name])
      put :update, id: @report.name, report: my_changed_report
      @report.reload
      expect(@report.terms).to eq([@term, @term2])
    end
  end
  describe 'DELETE destroy' do
    it 'requires authentication' do
      delete :destroy, report: report, id: report.name
      expect(response.status).to eq(401)
    end
    it 'finds the selected report' do
      delete :destroy, report: report, id: report.name
      expect(assigns(:report)).to eq(report)
    end
    it 'deletes a report in the database' do
      establish_current_user(user)
      @report = create(:report)
      expect{
        delete :destroy, report: @report, id: @report.name
      }.to change(Report, :count).by(-1)
    end
  end
  describe 'POST create' do
    it 'requires authentication' do
      post :create, report: report
      expect(response.status).to eq(401)
    end
    it 'add a report to the database' do
      establish_current_user(user)
      expect{
        post :create, report: attributes_for(:report)
      }.to change(Report, :count).by(1)
    end
    it "won't add the report without authentication" do
      expect{
        post :create, report: attributes_for(:report)
      }.to change(Report, :count).by(0)
    end
    it 'returns back the added report' do
      establish_current_user(user)
      @report = attributes_for(:report,
        name: 'My Report')
      post :create, report: @report
      expect(assigns(:report).name).to eq('My Report')
    end
  end
  describe 'upload' do
    it 'finds specified report' do
      establish_current_user(user)
      put :upload, id: report.name
      expect(assigns(:report)).to eq(report)
    end
    it 'updates new report object with timestamp' do
      establish_current_user(user)
      @report = create(:report)
      expect(@report.timestamp).to eq(nil)
      put :upload, 
        id: @report.name,
        image: File.open('app/assets/images/nd-gray.png')
      @report.reload
      current_time = Time.now.to_i
      expect(@report.timestamp).to be > 1437503331
    end
    it 'updates a report object that already has timestamp' do
      establish_current_user(user)
      @report = Report.create(name: 'my term', timestamp: 123456789)
      put :upload, 
        id: @report.name,
        image: File.open('app/assets/images/nd-gray.png')
      @report.reload
      expect(@report.timestamp).to be > 1437503331
    end
    it 'uploads a file' do
      establish_current_user(user)
      @report = Report.create(name: 'my term')
      put :upload, 
        id: @report.name,
        image: fixture_file_upload('app/assets/images/nd-gray.png')
      @report.reload
      @report_photo = PhotoMapper.new(@report.name, @report.timestamp)
      url = URI(@report_photo.image_url)
      response = Net::HTTP.get_response(url)
      expect(response.code).to eql('200')
    end
  end
end
