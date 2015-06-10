require 'rails_helper'

describe 'User Class' do
  # Just remember that the 'build' method only creates the object
  # It doesn't actually save it on the Database
  let(:user) { create(:user) }

  it 'is valid' do
    expect(user).to be_valid
  end
  it 'can do anything!' do
    expect(user.can(:action)).to be true
  end
  it 'is logged in' do
    expect(user.logged_in?).to be true
  end
end
