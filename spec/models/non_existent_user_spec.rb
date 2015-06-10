require 'rails_helper'

describe 'NonExistentUser class' do
  let(:na) { NonExistentUser.new }
  it 'is valid' do
    expect(na).to be_valid
  end
  it "cannot do anything" do
    expect(na.can(:anything)).to eq(false)
  end
  it "is logged in" do
    expect(na.logged_in?).to eq(true)
  end
  it 'defaults ned_id to NonExistentUser' do
    expect(na.net_id).to eq('NonExistentUser')
  end
end
