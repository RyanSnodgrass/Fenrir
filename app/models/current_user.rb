class CurrentUser
  def self.find_by(userfinder)
    User.find_by(net_id: userfinder) || AnonymousUser.find
  end
end
