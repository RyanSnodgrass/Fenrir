# This class returns a User object with the net_id 'anonymous'
class AnonymousUser
  def self.find
    User.find_by(net_id: 'anonymous')
  end
end
