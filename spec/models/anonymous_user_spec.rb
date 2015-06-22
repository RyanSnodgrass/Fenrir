require 'rails_helper'

describe 'AnonymousUser class' do
  let(:anon) { AnonymousUser.new }
  it 'is valid' do
    expect(anon).to be_valid
  end
  it "cannot do anything" do
    expect(anon.can(:anything)).to eq(false)
  end
  it "is not logged in" do
    expect(anon.logged_in?).to eq(false)
  end
  it 'defaults ned_id to anonymous' do
    expect(anon.net_id).to eq('anonymous')
  end
end
