require 'rails_helper'

describe 'CurrentUser class' do
  it 'returns an existing user by net_id' do
    user = create(:user)
    my_user = CurrentUser.find_by(user.net_id)
    expect(my_user).to eq(user)
  end
  it "returns an anonymous user if user doesn't exist" do
    anon = create(:anonymous)
    user = build(:user)
    expect(CurrentUser.find_by(user.net_id)).to eq(anon)
  end
  it 'returns a standard error if the user does not exist nor anonymous' do
    user = build(:user)
    expect{CurrentUser.find_by(user.net_id)}.to raise_error(StandardError)
  end
end
