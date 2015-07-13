require 'rails_helper'

RSpec.describe SearchController do
  describe 'typeahead' do
    it 'renders json' do
      Term.create(name: "my term", definition: "New York")
      get :typeahead, query: 'my'
      parsed_body = response.header['Content-Type']
      expect(parsed_body).to eq('application/json; charset=utf-8')
    end
    it 'renders json with the names of the terms' do
      Term.create(name: 'my term', definition: 'New York')
      Term.reindex
      get :typeahead, query: 'my'
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(['my term'])
    end
  end
end
