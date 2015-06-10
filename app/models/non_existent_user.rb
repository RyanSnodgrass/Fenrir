# This class returns a User object with the net_id 'anonymous'
#
# We want an error to be raised in the event of no anonymous user found
# That is a special case and it should notify us instead of seeping nil
# down the code pipeline
class NonExistentUser < User
  property :net_id, default: 'NonExistentUser'

  def logged_in?
    true
  end

  def can(action)
    false
  end
end
