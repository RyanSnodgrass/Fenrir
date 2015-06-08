class User
  include Neo4j::ActiveNode
  property :net_id, constraint: :unique
  property :admin_emeritus, type: Boolean
end
