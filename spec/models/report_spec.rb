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

  context 'for selecting terms' do
    it 'parses for select2 into id/text pairs'  do
      r = create(:report)
      t = create(:term)
      r.terms << t
      expect(r.selectable_terms).to eq([{id: t.id, text: t.name}].to_json)
    end
    it 'parses for select2 into id/text pairs for 2 terms' do
      r = create(:report)
      t = create(:term)
      t2 = Term.create(name: 'my term')
      r.terms << t
      r.terms << t2
      expect(r.selectable_terms).to eq([{id: t.id, text: t.name}, {id: t2.id, text: t2.name}].to_json)
    end
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
    it 'performs a name, description search boosting name' do
      Report.create(name: 'Awesome Report', description: 'New York')
      Report.create(name: 'Manhattan', description: 'Its kinda awesome')
      Report.create(name: 'super Awesome Report', description: 'still awesome')
      Report.create(name: 'Yonkers', description: 'broadway')
      Report.create(name: 'awesome stupendous', description: 'wall street')
      Report.create(name: 'Queens', description: 'Bronx')
      Report.reindex
      r = Report.search 'aweso', fields: ['name^10', 'description']
      expect(r.count).to eq(4)
      expect(r[-1].name).to eq('Manhattan')
    end
    it 'searches name/description through reports and terms' do
      Report.create(name: 'Awesome Report', description: 'New York')
      Report.create(name: 'Manhattan', description: 'Its kinda awesome')
      Report.create(name: 'super Awesome Report', description: 'still awesome')
      Report.create(name: 'Yonkers', description: 'broadway')
      Report.create(name: 'awesome stupendous', description: 'wall street')
      Report.create(name: 'Queens', description: 'Bronx')
      Term.create(name: 'awesome', definition: 'laguardia')
      Term.create(name: 'Awesome Term', definition: 'New York')
      Term.create(name: 'Manhattan', definition: 'Its kinda awesome')
      Term.create(name: 'super Awesome Term', definition: 'still awesome')
      Term.create(name: 'Yonkers', definition: 'broadway')
      Term.create(name: 'awesome stupendous', definition: 'wall street')
      Term.create(name: 'Queens', definition: 'Bronx')
      Report.reindex
      Term.reindex
      r = Report.search(
        'aweso',
        index_name: [Report.searchkick_index.name, Term.searchkick_index.name],
        fields: ['name^10', 'description', 'definition']
      )
      expect(r.count).to eq(9)
      expect(r[-1].name).to eq('Manhattan')
    end
  end
end
