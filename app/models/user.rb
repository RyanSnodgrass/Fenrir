class User

  attr_accessor :name, :security_roles

  def initialize( netid )
    @name = netid
    @name ||= "No name found"
  end

  def security_roles
    @roles ||= get_security_roles
  end

  def can( action )
    case action
    when :publish_report
      security_roles.include? "Report Publisher"
    end
  end

  private
  def get_security_roles
    # call web service
    [ "Report Publisher" ]
  end

end