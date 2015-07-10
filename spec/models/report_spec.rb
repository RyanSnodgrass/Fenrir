require 'rails_helper'

describe 'Report Class' do
  let(:report) { create(:report) }

  it 'is valid' do
    expect(report).to be_valid
  end

  it 'has an association with one term' do
    term = create(:term)
    report.terms << term
    @reloaded_report = Report.find_by(name: report.name)
    expect(@reloaded_report.terms).to eq([term])
  end
  context 'search feature' do
    it 'uses search to find reports' do
      @report = create(:report)
      @report.reindex
      Report.searchkick_index.refresh
      results = Report.search @report.name
      expect(results.first.name).to eq(@report.name)
    end

    it 'uses search for specific field like description' do
      @report = Report.new
      @report.name = 'my report'
      @report.description = 'my description is at New York'
      @report.save
      @report.reindex
      @report2 = Report.new
      @report2.name = 'New York'
      @report2.description = 'my description is at Miami'
      @report2.save
      @report2.reindex
      Report.searchkick_index.refresh
      results = Report.search 'New York', fields: [:description]
      expect(results.first.name).to eq('my report')
      expect(results.count).to eq(1)
    end

    it 'only searches by name and description' do
      @report = create(:report)
      @report.reindex
      Report.searchkick_index.refresh
      results = Report.search @report.type
      expect(results.count).to eq(0)
    end
  end
end
