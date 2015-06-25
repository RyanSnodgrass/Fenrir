require 'rails_helper'

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
end
