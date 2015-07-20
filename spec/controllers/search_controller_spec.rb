require 'rails_helper'

RSpec.describe SearchController do
  describe 'search_all' do
    it 'renders json' do
      Report.create(name: 'Awesome Report', description: 'New York')
      Report.reindex
      get :search_all, query: 'aweso'
      parsed_body = response.header['Content-Type']
      expect(parsed_body).to eq('application/json; charset=utf-8')
    end
    # it 'renders json with names and definition of the results', focus: true do
    #   r1 = Report.create(name: 'Awesome node', description: 'New York')
    #   r2 = Report.create(name: 'Manhattan', description: 'Its kinda awesome')
    #   t1 = Term.create(name: 'awesome', definition: 'laguardia')
    #   t2 = Term.create(name: 'Queens', definition: 'Bronx')
    #   Report.reindex
    #   Term.reindex
    #   get :search_all, query: 'aweso'
    #   parsed_body = JSON.parse(response.body)
    #   expect(parsed_body.first.first[1].key?('name')).to eq(true)
    #   if parsed_body.first.key?('term')
    #     expect(parsed_body.first.first[1].key?('definition')).to eq(true)
    #   else
    #     expect(parsed_body.first.first[1].key?('description')).to eq(true)
    #   end
    # end
    it 'definition matches are last' do
      r1 = Report.create(name: 'Awesome Report', description: 'New York')
      r2 = Report.create(name: 'Manhattan', description: 'Its kinda awesome')
      t1 = Term.create(name: 'awesome', definition: 'laguardia')
      t2 = Term.create(name: 'Queens', definition: 'Bronx')
      Report.reindex
      Term.reindex
      get :search_all, query: 'aweso'
      expect(assigns(:results)[-1].name).to eq('Manhattan')
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
