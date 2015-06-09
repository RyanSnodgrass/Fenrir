require 'rails_helper'

describe 'User Class' do
  # Just remember that the 'build' method only creates the object
  # It doesn't actually save it on the Database
  let(:user) { create(:user) }

  it 'is valid' do
    expect(user).to be_valid
  end
  # it "won't create if not unique" do
  #   user1 = User.new
  #   user2 = User.new
  #   user1.net_id = 'example'
  #   user2.net_id = 'example'
  #   user1.save
  #   expect(user2.save).to raise_error(NameError)
  # end
end
