class Report
  include Neo4j::ActiveNode
  searchkick  word_start: [:name], autocomplete: [:name]
  def search_data
    {
      name: name,
      description: description
    }
  end
  property              :name
  property              :description
  property              :tableau_link
  property              :type
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
  def selectable_terms
    @selectable_terms = []
    self.terms.each do |t| 
      @selectable_terms << {id: t.id, text: t.name}
    end
    @selectable_terms.to_json
  end
end
