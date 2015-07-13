# This is where all search related queries go
class SearchController < ApplicationController
  def typeahead_terms
    results = Term.search params[:query], fields: [{ name: :word_start }]
    render json: results.map(&:name)
  end

  def typeahead_terms_all
    results = Term.all
    render json: results.map(&:name)
    # render json: results.map { |r| [r.name, r.definition] }
  end

  def typeahead_reports_all
    results = Report.all
    render json: results.map(&:name)
    # render json: results.map { |r| [r.name, r.description] }
  end
end
