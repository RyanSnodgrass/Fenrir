require 'rails_helper'

RSpec.describe SearchController do
  xdescribe 'typeahead_terms' do
    it 'renders json' do
      Term.create(name: 'my term', definition: 'New York')
      get :typeahead_terms, query: 'my'
      parsed_body = response.header['Content-Type']
      expect(parsed_body).to eq('application/json; charset=utf-8')
    end
    it 'renders json with the names of the terms' do
      Term.create(name: 'my term', definition: 'New York')
      Term.reindex
      get :typeahead_terms, query: 'my'
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(['my term'])
    end
    it 'searches with partial matches' do
      Term.create(name: 'Academic Calendar', definition: 'New York')
      Term.reindex
      get :typeahead_terms, query: 'Cale'
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(['Academic Calendar'])
    end
  end
  describe 'typeahead_terms_all' do
    it 'renders json with all terms' do
      @term = create(:term)
      @term2 = Term.create(name: 'Academic Calendar', definition: 'New York')
      get :typeahead_terms_all
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq([@term.name, @term2.name])
    end
  end
end
