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
    it 'performs partial word search for name' do
      Term.create(name: 'Academic Calendar', definition: 'New York')
      Term.create(name: 'Student', definition: 'Manhattan')
      Term.reindex
      r = Term.search 'calend', fields: [{name: :word_start}]
      expect(r.first.name).to eq('Academic Calendar')
      r = Term.search 'acad', fields: [{name: :word_start}]
      expect(r.first.name).to eq('Academic Calendar')
      r = Term.search 'stud', fields: [{name: :word_start}]
      expect(r.first.name).to eq('Student')
      r = Term.search 'student', fields: [{name: :word_start}]
      expect(r.first.name).to eq('Student')
      r = Term.search 'academic', fields: [{name: :word_start}]
      expect(r.first.name).to eq('Academic Calendar')
    end
    it 'performs partial word search for definition' do
      Term.create(name: 'Awesome Term', definition: 'New York')
      Term.create(name: 'Manhattan', definition: 'Its kinda awesome')
      Term.reindex
      r = Term.search 'aweso', fields: [:definition]
      expect(r.count).to eq(1)
      expect(r.first.name).to eq('Manhattan')
      r = Term.search 'york', fields: [:definition]
      expect(r.count).to eq(1)
      expect(r.first.name).to eq('Awesome Term')
    end
    it 'performs a name, definition search boosting name' do
      Term.create(name: 'Awesome Term', definition: 'New York')
      Term.create(name: 'Manhattan', definition: 'Its kinda awesome')
      Term.create(name: 'super Awesome Term', definition: 'still awesome')
      Term.create(name: 'Yonkers', definition: 'broadway')
      Term.create(name: 'awesome stupendous', definition: 'wall street')
      Term.create(name: 'Queens', definition: 'Bronx')
      Term.reindex
      r = Term.search 'aweso', fields: ['name^10', 'definition']
      expect(r.count).to eq(4)
      expect(r[-1].name).to eq('Manhattan')
    end
  end
end
