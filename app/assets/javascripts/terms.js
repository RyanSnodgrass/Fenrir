
$(".terms.show").ready(function() {
  typed_search_val = $('#search1').val();
  executeFilter(typed_search_val);
  bindTypeaheadSearchBehavior();
  $('#search1').watermark('Search');
});

function bindTypeaheadSearchBehavior() {
  // every keyup event starts a search that will
  // execute in 200ms unless another key is pressed!
  // typeahead binding
  var pendingPartialSearch;
  var key_press_delay = 200;
  $('#search1').bind('input', function() {
    typed_search_val = $("#search1").val()
    if ( typed_search_val.length == 0 || typed_search_val.length >= 3 ) {
      // if the user is still typing, cancel the pending search
      if ( pendingPartialSearch != null ) {
         clearTimeout( pendingPartialSearch );  // stop the pending one
      }
      console.log( typed_search_val );
      // set a new search to execute in 200ms  
      pendingPartialSearch = setTimeout( 
        function() {
          console.log('executre filter inside bindtypeahead');
          executeFilter(typed_search_val);
        }, 
        key_press_delay 
      )
    }
  });
}

function executeFilter(t_s_v) {
  // var searchURL = getSearchURL(1)
  // console.log(searchURL)
  displayLoading()
  $.get( '/terms/search', {'search_query': t_s_v }, function(data) {
    $('#search_results').html(data)
    highlightSearchString()
  });


  // this is where the actual load function happens
  // .load( url to go, then functions to run when complete )
  // $('#search_results').load( 
  //   '/terms/search',
  //   { 'search_query': t_s_v },
  //   function(data) {
  //     highlightSearchString()
  //     // bindInfiniteScrollBehavior()
  //   }
  // )
}

function highlightSearchString() {
  search_string = $('#search1').val()
  $(".do_highlight").highlight( search_string )
}

function displayLoading() {
  $('#search_results').html("<div class='search_results_msg'><img src='/assets/ajax-loader.gif'></div>")
}
