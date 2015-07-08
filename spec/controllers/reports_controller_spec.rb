require 'rails_helper'
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
      }.to change(Report,:count).by(-1)
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
        name: 'My Report'
      )
      post :create, report: @report
      expect(assigns(:report).name).to eq('My Report')
    end
  end
end
