require 'rails_helper'

describe 'Term Class' do
  let(:term) { create(:term) }
  it 'is valid' do
    expect(term).to be_valid
  end
end
