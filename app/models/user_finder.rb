# This class serves to check if the session variable contains the ('cas') value
# It returns the net_id of the user if it does
# and 'anonymous' if it does not
class UserFinder
  def initialize(session)
    @session = session
  end

  def find_logged_in_user
    @session.key?('cas') ? logged_in_name : not_logged_in_name
  end

  def name
    @name = find_logged_in_user
  end

  private

  def logged_in_name
    @session['cas']['user']
  end

  def not_logged_in_name
    'anonymous'
  end
end
