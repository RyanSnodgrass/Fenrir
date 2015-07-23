$(document).ready(function(){
  $('#createTermButton').click(function() {
    var term = $('#tname').val();
    term_new = {
       "name": term,
       "definition": "",
       "source_system": "",
       "possible_values": "",
       "data_availability": "",
       "notes": ""};
      $('a.close-reveal-modal').trigger('click');
      createTerm(term_new);
  });
  function createTerm( term_object ) {  
    $.ajax({
       url : '/terms',
       type: 'POST',
       data: { "term": term_object },
       success: function (data) {
        addSuccessMessage("success", "<b>Term " + term_object.name +   " successfully. Please wait for Term Detail page display.</b>");
        showSuccessMessage();
        var url = escape('/terms/'+ term_object.name);
        window.location = url;
     },
       error: function( xhr, ajaxOptions, thrownError) {
       addValidationError( "alert", "Added Term, " +term_object.name+ ", has error: " + xhr.responseText);
       showValidationErrors()
     }
    })
  }
});

$(".terms.show").ready(function() {

  typed_search_val = $('#search1').val();
  executeFilter(typed_search_val);
  bindTypeaheadSearchBehavior();
  $('#search1').watermark('Search');

  $('#updateTermButton').click(function() {
    clearValidationErrors();
    var term_object = {}
    if (updateTermObject(term_object) == false){
      return false;
    }
    updateTerm(term_object);
  });

  $('#showJSONButton').click( function() {
    $('#json_container').toggle()
  });

  $('#deleteConfirm').click( function() {
    $('a.close-reveal-modal').trigger('click')
    deleteTerm(null)
  });
  $('#deleteCancel').click( function() {
    $('a.close-reveal-modal').trigger('click')
  });

  function updateTermObject(term_object ) {
    clearValidationErrors()
    tinymce.triggerSave();
    $('.editable').each( function() {
      id = $(this).attr('id');
      if ( id ) {
        p = tinymce.get(id).getContent()
        if (id == "name") {
          var StrippedString = p.replace(/(<([^>]+)>)/ig,"");
          p = StrippedString;
        }
        term_object[id] = p;
      }
    })
    term_object["sensitivity_classification"] = $('#sensitivity_classification').val();
    term_object["access_designation"] = $('#access_designation').val();
    term_object["perm_group"] = $('#permission-group').val();
    // group_name = 
    // term_object["permission_group"].push( {name: group_name} )

    // term_object["stakeholders"] = []
    // var office_array=[]

    // var i = 0;
    // var exitRACI = false;
    // var dupRACI = false;
    // var office_text =null;
    // $('.raci_row').each( function() {
    //   stake = $(this).data('raci-stake')
    //   console.log("stake value is " + stake);
    //   json_array = $('#raci' + i ).select2('data')
    //   if (stake == "Responsible" && json_array.length >1){
    //     addValidationError( "alert", "Only one <b>Responsible</b> office is allowed.")
    //   }

    //   for (var j = 0; j < json_array.length; j++ ) {
    //     term_object["stakeholders"].push( { name: json_array[j]["text"], stake: stake} )
    //     var office_exist = false;
    //     if (office_array !=null )  {
    //        for (var k=0; k<office_array.length; k++){
    //           if (json_array[j]["text"] == office_array[k]["name"])  {
    //             office_exist = true;
    //             break;
    //           }
    //        }
    //      }

    //     if (!office_exist)
    //       office_array.push({name: json_array[j]["text"]})
    //     else{
    //       if (!office_text)
    //         office_text = json_array[j]["text"]
    //       else if (office_text.search( json_array[j]["text"]) <0)
    //         office_text  += " , "+ json_array[j]["text"]
    //       }

    //     }
    //     i++;
    // });

    // if (office_text !=null)
    //   addValidationError( "alert", "<b>" +  office_text + "</b>" +  " has repeated in the RACI entry. Each office is assigned for one role per term.");
    //   console.log( term_object );

    if ( showValidationErrors()  == true ) { 
      return false;
    }
    return term_object;
  }
  function updateTerm( term_object ) {
    $.ajax({
      url: term_object.id,
      type: 'PUT',
      data: { "term": term_object
      },
     // data: { "termJSON": term_object },
      //dataType: 'json',
      success: function (data) {
         var url = escape(term_object.name);
         window.location.href = url;
         addSuccessMessage("success", "<b>" + term_object.name + "</b>" +  " updated successfully. " );
         showSuccessMessage();
      },
      error: function( xhr, ajaxOptions, thrownError) {
         addValidationError( "alert", "Update term has errors: " + xhr.responseText);
         showValidationErrors(); 
      }
    })
  }
  function deleteTerm( termid ) {
    $.ajax({
      url:  $('#mytinyDelete').attr('ajax_path'),
      type: 'DELETE',
      success: function(data, status, xhr){
        addSuccessMessage("success", "<b>" + data.message + ". Please wait for Glossary Page display.</br>" )
        showSuccessMessage();
        var myHashLink = "browse/terms";
        window.location.href = '/users/myprofile';
      },
      error: function(xhr, status, error) {
        addValidationError( "alert", "Delete term has errors: " + xhr.responseText);
        showValidationErrors()
      }
    });
  }
});



//// SEARCH FUNCTION /////


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
      // set a new search to execute in 200ms  
      pendingPartialSearch = setTimeout( 
        function() {
          executeFilter(typed_search_val);
        }, 
        key_press_delay 
      )
    }
  });
}

function executeFilter(t_s_v) {
  // var searchURL = getSearchURL(1)
  displayLoading()
  $.get( '/terms/search', {'search_query': t_s_v }, function(data) {
    $('#search_results').html(data)
    // highlightSearchString()
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

// function highlightSearchString() {
//   search_string = $('#search1').val()
//   $(".do_highlight").highlight( search_string )
// }

function displayLoading() {
  $('#search_results').html("<div class='search_results_msg'><img src='/assets/ajax-loader.gif'></div>")
}
