require 'rails_helper'

RSpec.describe 'routing to home', type: :routing do
  it 'routes / to welcome#index' do
    expect(get: '/').to route_to(
      controller: 'welcome',
      action: 'index'
    )
  end
end

RSpec.describe 'dataset routing', type: :routing do
  describe 'GET SHOW' do
    it "goes to the show method from 'datasets/:id'" do
      expect(get: '/datasets/1').to route_to(
        controller: 'datasets',
        action: 'show',
        id: '1'
      )
    end
  end
end

RSpec.describe 'Report routing', type: :routing do
  describe 'GET SHOW' do
    it "goes to the show method from 'reports/:id'" do
      expect(get: '/reports/1').to route_to(
        controller: 'reports',
        action: 'show',
        id: '1'
      )
    end
  end
end

RSpec.describe 'Term routing', type: :routing do
  describe 'GET SHOW' do
    it "goes to the show method from 'terms/:id'" do
      expect(get: '/terms/1').to route_to(
        controller: 'terms',
        action: 'show',
        id: '1'
      )
    end
    it 'does the simple be_routable' do
      expect(get: '/terms/:id').to be_routable
    end
    it 'uses term_path rails magic to route to terms#show method' do
      term = create(:term)
      expect(get: term_path(term.name)).to route_to(
        controller: 'terms',
        action: 'show',
        id: term.name
      )
    end
  end
  describe 'search' do
    it 'routes to terms controller search action' do
      expect(get: '/terms/search').to route_to(
        controller: 'terms',
        action: 'search'
      )
    end
  end
end

RSpec.describe 'Search Routing', type: :routing do
  it 'uses the explicit call for the route for the terms' do
    expect(get: '/search/typeahead_terms/1').to route_to(
      controller: 'search',
      action: 'typeahead_terms',
      query: '1'
    )
  end
  it 'uses the explicit call for the route for reports' do
    expect(get: '/search/typeahead_reports_all').to route_to(
      controller: 'search',
      action: 'typeahead_reports_all'
      )
  end
end
