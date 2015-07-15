require 'rails_helper'

RSpec.describe SearchController do
  describe 'typeahead_terms' do
    it 'renders json' do
      Report.create(name: 'Awesome Report', description: 'New York')
      Report.create(name: 'Manhattan', description: 'Its kinda awesome')
      Report.create(name: 'super Awesome Report', description: '')
      Report.create(name: 'Yonkers', description: 'broadway')
      Report.create(name: 'awesome stupendous', description: 'wall street')
      Report.create(name: 'Queens', description: 'Bronx')
      Term.create(name: 'awesome', definition: 'laguardia')
      Term.create(name: 'Awesome Term')
      Term.create(name: 'Manhattan', definition: 'Its kinda awesome')
      Term.create(name: 'super Awesome Term', definition: 'still awesome')
      Term.create(name: 'Yonkers', definition: 'broadway')
      Term.create(name: 'awesome stupendous', definition: 'wall street')
      Term.create(name: 'Queens', definition: 'Bronx')
      Report.reindex
      Term.reindex
      get :typeahead_terms, query: 'aweso'
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
