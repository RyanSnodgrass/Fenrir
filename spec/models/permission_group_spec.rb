require 'rails_helper'

describe 'PermissionGroup Class' do
  let(:pg) { create(:permission_group) }
  it 'is valid' do
    expect(pg).to be_valid
  end
end
