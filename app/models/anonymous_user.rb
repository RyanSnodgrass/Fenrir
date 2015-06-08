# This class returns a User object with the net_id 'anonymous'
#
# We want an error to be raised in the event of no anonymous user found
# That is a special case and it should notify us instead of seeping nil
# down the code pipeline
class AnonymousUser
  class NoAnonymousUserFound < StandardError; end
  def self.find
    User.find_by(net_id: 'anonymous') or
      raise NoAnonymousUserFound
  end
end
