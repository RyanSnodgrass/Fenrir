$(document).ready(function(){
  $('.typeahead.tt-input').bind("keypress",function(e){
    if(e.keyCode == 13){
      send_search_request_for_all()
    }
  });
  function send_search_request_for_all(){
    search_val = $('.typeahead.tt-input').val()
    $.ajax({
      url: '/search/typeahead_terms/' + search_val,
      success: function (data) {
        $('#search_everything_results').html(data)
      }
    })
  }

});