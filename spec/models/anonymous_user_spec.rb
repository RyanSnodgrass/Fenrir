require 'rails_helper'

describe 'AnonymousUser class' do
  it 'returns a user object' do
    create(:anonymous)
    @anonymous_user = AnonymousUser.find
    expect(@anonymous_user).to be_kind_of(User)
  end

  it "returns a user with 'anonymous' net_id" do
    create(:anonymous)
    @anonymous_user = AnonymousUser.find
    expect(@anonymous_user.net_id).to eq('anonymous')
  end
  it "raises an error if it can't find an anonymous user" do
    expect { AnonymousUser.find }.to raise_error(StandardError)
  end
end