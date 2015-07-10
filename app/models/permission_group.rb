# Documentation goes here
class PermissionGroup
  include Neo4j::ActiveNode
  searchkick
  def search_data
    {
      name: name
    }
  end
  property              :name, constraint: :unique
  property              :created_at
  property              :updated_at
  property              :created_by
  property              :updated_by
  validates_presence_of :name
  has_many :out,        :terms
end
