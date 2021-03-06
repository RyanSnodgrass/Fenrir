# require 'rails_helper'

# describe 'UserFinder Class with maunually written session value' do
#   let :cas_session do
#     { 'cas' => { 'user' => 'rsnodgra',
#                  'ticket' => 'ST-516271-B9XA0vT6ncxmPgzDsUKt-cas',
#                  'extra_attributes' => {} } }
#   end
#   let :non_cas_session do
#     Hash.new
#   end
#   it "assigns 'anonymous' when no cas is detected" do
#     i = UserFinder.new(non_cas_session)
#     expect(i.name).to eq('anonymous')
#   end
#   it 'assigns cas user as name' do
#     i = UserFinder.new(cas_session)
#     expect(i.name).to eq('rsnodgra')
#   end
#   it 'assigns cas user with one long function call' do
#     i = UserFinder.new(cas_session).name
#     expect(i).to eq('rsnodgra')
#   end
#   it "assigns anonymous with long function call without '[:cas]'" do
#     i = UserFinder.new(non_cas_session).name
#     expect(i).to eq('anonymous')
#   end
# end
# RSpec.configure do |c|
#   c.infer_base_class_for_anonymous_controllers = false
# end
# RSpec.describe UserFinder, type: :controller do
#   controller do
#     def index
#       render nothing: true
#     end
#   end
#   context 'with full access to true session object' do
#     it 'tells me my name is anonymous' do
#       get :index
#       i = UserFinder.new(session).name
#       expect(i).to eq('anonymous')
#     end
#     it 'and I manually set a session user it tells me my user name' do
#       user = create(:user)
#       establish_current_user(user)
#       get :index
#       i = UserFinder.new(session).name
#       expect(i).to eq(user.net_id)
#     end
#   end
# end
