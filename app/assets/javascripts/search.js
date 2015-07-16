$(document).ready(function(){
  $('.typeahead.tt-input').bind("keypress",function(e){
    if(e.keyCode == 13){
      $('.tt-menu').hide()
      send_search_request_for_all()
    }
  });
  function send_search_request_for_all(){
    search_val = $('.typeahead.tt-input').val()
    $.get('/search/search_all/' + search_val + '.json', function(data) {
      
      for (var i = 0; i < data.length; i++) {
        var ind_result = data[i];
        var beginning_string = '<li>' +
        '<h1>' + Object.keys(ind_result)  + '</h1>' +
        '<h2>' + ind_result[Object.keys(ind_result)].name + '</h2>'
        if (Object.keys(ind_result) == 'term') {
            var html = beginning_string + 
                '<p>definition:' + ind_result['term'].definition + '</p>' +
                '</li>';
        } 
        else {
            var html = beginning_string + 
                '<p>description:' + ind_result['report'].description + '</p>' +
                '</li>';
        }
          $('#search_everything_results').append(html);
      }
    }, "json" );
  }
});
