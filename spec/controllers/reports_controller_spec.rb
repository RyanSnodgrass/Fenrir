require 'rails_helper'
# require 'json'
RSpec.describe ReportsController do
  let(:report) { create(:report) }
  let(:user) { create(:user) }
  let(:term) { create(:term) }
  describe 'GET show' do
    it 'routes to show' do
      get :show, id: report.name
      expect(response.status).to eq(200)
    end
    it 'assigns a report' do
      get :show, id: report.name
      expect(assigns(:report)).to eq(report)
    end
    it 'assigns all terms' do
      get :show, id: report.name
      term = create(:term)
      termtwo = create(:term, name: 'Academic Year')
      expect(assigns(:terms)).to eq([term, termtwo])
    end
  end
end
