# This class returns a User object with the net_id 'anonymous'
#
# We want an error to be raised in the event of no anonymous user found
# That is a special case and it should notify us instead of seeping nil
# down the code pipeline
class AnonymousUser < User
  property :net_id, default: 'anonymous'
  # class NoAnonymousUserFound < StandardError; end
  # def initialize
  #   User.find_by(net_id: 'anonymous') or
  #     raise NoAnonymousUserFound
  # end

  def logged_in?
    false
  end

  def can(action)
    false
  end
end
