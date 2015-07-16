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
        if (Object.keys(ind_result) == 'term') {
            var html = '<div class="searchResult termSearchResult">' +
              '<div class="result_header">' +
                '<div class="result_icon result_icon_term"></div>' +
                '<h1 class="result_title">' + 
                  '<a class="do_highlight res_title" href="../' + 
                    Object.keys(ind_result) + 's/'+ ind_result[Object.keys(ind_result)].name + '">' +
                    ind_result[Object.keys(ind_result)].name +
                  '</a>' +
                '</h1>' +
              '</div>' +
              '<div class="do_highlight result_body">' +
                ind_result['term'].definition +
              '</div>' +
            '</div>'
        } 
        else {
          var html = '<div class="searchResult reportSearchResult">' +
            '<div class="result_header">' +
              '<div class="result_icon result_icon_report"></div>' +
              '<h1 class="result_title">' + 
                '<a class="do_highlight res_title" href="../' + 
                  Object.keys(ind_result) + 's/'+ ind_result[Object.keys(ind_result)].name + '">' +
                  ind_result[Object.keys(ind_result)].name +
                '</a>' +
              '</h1>' +
            '</div>' +
            '<div class="do_highlight result_body">' +
              ind_result['report'].description +
            '</div>' +
          '</div>'
        }
          $('#search_everything_results').append(html);
      }
    }, "json" );
  }
});


