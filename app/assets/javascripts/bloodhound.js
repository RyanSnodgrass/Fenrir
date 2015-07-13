$(document).ready(function(){
  var terms = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    // url points to a json file that contains an array of country names, see
    // https://github.com/twitter/typeahead.js/blob/gh-pages/data/countries.json
    prefetch: 'search/typeahead_terms_all.json'
  });
  var reports = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    // url points to a json file that contains an array of country names, see
    // https://github.com/twitter/typeahead.js/blob/gh-pages/data/countries.json
    prefetch: 'search/typeahead_reports_all.json'
  });
   
  $('#multiple-datasets .typeahead').typeahead({
    highlight: true
  },
  {
    name: 'terms',
    source: terms,
    templates: {
      header: '<h3 class="league-name">NBA Teams</h3>'
    }
  },
  {
    name: 'reports',
    source: reports,
    templates: {
      header: '<h3 class="league-name">NHL Teams</h3>'
    }
  });
});
