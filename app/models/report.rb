class Report
  include Neo4j::ActiveNode
  searchkick
  property              :name
  property              :description
  property              :tableau_link
  property              :report_type
  property              :thumbnail_uri
  property              :gridsize
  property              :timestamp
  property              :embedJSON
  validates_presence_of :name
  has_many :in,         :terms
end
