require 'rails_helper'
describe 'Report Class' do

  let(:report) { create(:report) }
  it 'is valid' do
    expect(report).to be_valid
  end
  it 'has an association with one term' do
    term = create(:term)
    report.terms  << term
    @reloaded_report = Report.find_by(name: report.name)
    expect(@reloaded_report.terms).to eq([term])
  end
  it 'uses search to find reports' do
    @report = create(:report)
    @report.reindex
    Report.searchkick_index.refresh
    results = Report.search @report.name
    expect(results.first.name).to eq(@report.name)
  end
end
