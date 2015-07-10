require 'rails_helper'
RSpec.configure do |config|
  config.before :each do
    Term.reindex
    Term.searchkick_index.refresh
  end
end

describe 'Term Class' do
  let(:term) { create(:term) }
  it 'is valid' do
    expect(term).to be_valid
  end

  it 'has an association with one permission group' do
    pg = create(:permission_group)
    term.permission_group = pg
    @reloaded_term = Term.find_by(name: term.name)
    expect(@reloaded_term.permission_group).to eq(pg)
  end

  it 'reflects a deleted association' do
    pg = create(:permission_group)
    term.permission_group = pg
    expect(term.permission_group).to eq(pg)
    pg.destroy
    @reloaded_term = Term.find_by(name: term.name)
    expect(@reloaded_term.permission_group).to eq(nil)
  end
  context 'search function' do
    it 'uses search to find terms' do
      @term = create(:term)
      @term.reindex
      Term.searchkick_index.refresh
      results = Term.search @term.name
      expect(results.first.name).to eq(@term.name)
    end

    it 'uses search for specific field like definition' do
      @term = Term.new
      @term.name = 'my term'
      @term.definition = 'my definition is at New York'
      @term.save
      @term.reindex
      @term2 = Term.new
      @term2.name = 'New York'
      @term2.definition = 'my definition is at Miami'
      @term2.save
      @term2.reindex
      Term.searchkick_index.refresh
      results = Term.search 'New York', fields: [:definition]
      expect(results.first.name).to eq('my term')
      expect(results.count).to eq(1)
    end

    it 'only searches by name and definition' do
      @term = create(:term)
      @term.reindex
      Term.searchkick_index.refresh
      results = Term.search @term.sensitivity_classification, fields: [:name]
      expect(results.count).to eq(0)
    end
  end
end
