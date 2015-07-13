class SearchController < ApplicationController
  def typeahead
    results = Term.search params[:query], fields: [:name]
    render json: results.map(&:name)
  end
end
