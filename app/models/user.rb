class User
  include Neo4j::ActiveNode
  property :net_id, constraint: :unique
  property :admin_emeritus, type: Boolean

  def can(action)
    true
  end
  def logged_in?
    true
  end
end
