class SearchController < ApplicationController
  def typeahead_terms
    results = Term.search params[:query], fields: [{name: :word_start}]
    render json: results.map(&:name)
  end
  def typeahead_reports
  end
end
