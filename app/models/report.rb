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
  property              :created_at
  property              :updated_at
  property              :created_by
  property              :updated_by
  validates_presence_of :name
  has_many :in,         :terms
end
