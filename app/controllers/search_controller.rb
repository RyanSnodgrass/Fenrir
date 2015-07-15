# This is where all search related queries go
class SearchController < ApplicationController
  def typeahead_all
    @results = Report.search(
      params[:query],
      index_name: [Report.searchkick_index.name, Term.searchkick_index.name],
      fields: ['name^10', 'description', 'definition']
    )
    render json: @results.map {
      |r| puts r.name, r['definition'] || r['description'] 
    }
  end

  def typeahead_terms_all
    @results = Term.all
    render json: @results.map(&:name)
  end

  def typeahead_reports_all
    @results = Report.all
    render json: @results.map(&:name)
    # render json: results.map { |r| [r.name, r.description] }
  end
end


