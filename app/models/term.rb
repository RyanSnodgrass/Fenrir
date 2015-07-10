# Documentation goes here
class Term
  include Neo4j::ActiveNode
  searchkick
  def search_data
    {
      name: name,
      definition: definition
    }
  end
  property              :name, constraint: :unique
  property              :definition
  property              :source_system
  property              :possible_values
  property              :notes
  property              :data_availability
  property              :sensitivity_classification
  property              :access_designation
  property              :sensitivity_access_notes
  property              :created_at
  property              :updated_at
  property              :created_by
  property              :updated_by
  validates_presence_of :name
  has_one  :in,         :permission_group
  has_many :out,        :reports
end
