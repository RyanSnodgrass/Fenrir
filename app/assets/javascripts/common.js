$(document).ready(function(){

  // if (new_report == true) {
  //   alert('new report');
  // };
    

  $('#editmode').change(function(){
    if ( this.checked ) {
      changetoeditmode();
    }
    else {
      changetoviewmode();
    }
  });

  $('#image').change( function() {
    $('form#report_image_upload').submit();
  });


  if (typeof office_json != 'undefined')  {
   $('.raci_input').select2({
        data:office_json,
        multiple: true,
        width: "500px"
    });

    $('.raci_input').each( function() {
      $(this).data().select2.updateSelection( $(this).data('init') )
    });

  }

 if (typeof term_gov_json != 'undefined')  {
   $('.term_input').select2({
        data:term_gov_json,
        multiple: true,
        width: "500px"
    });

    $('.term_input').val(function() {
      $(this).data().select2.updateSelection( $(this).data('init') )
    });

  }
  if (typeof security_roles_json != 'undefined')  {
   $('.role_input').select2({
        data:security_roles_json,
        multiple: true,
        width: "500px"
    });

    $('.role_input').val(function() {
      $(this).data().select2.updateSelection( $(this).data('init') )
    });
  }

  // if(typeof term_object != 'undefined')  {

    $('#updateTermButton').click(function() {
      console.log('update button clicked')
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
  // }


  if(typeof office_detail_json != 'undefined')  {

    $('#updateOfficeButton').click(function() {
    //alert("updating term object")
      if (updateOfficeObject(office_detail_json) == false)
        return false;

      updateOffice(office_detail_json)
    })

    $('#showOfficeButton').click( function() {
      $('#json_container').toggle()
    })

    $('#deleteConfirm').click( function() {
      $('a.close-reveal-modal').trigger('click')
      deleteOffice(office_detail_json.id)
    });
    $('#deleteCancel').click( function() {
      $('a.close-reveal-modal').trigger('click')
    });

  }

    // if(typeof permission_group_detail_json != 'undefined')  {

      $('#update-permission-group').click(function() {
        permission_group_object = {}
        if (updatePermissionGroupObject(permission_group_object) == false) {
          return false;
        }
        else {
          updatePermissionGroup(permission_group_object)
        }
      });
      $('#deleteConfirmpg').click( function() {
        $('a.close-reveal-modal').trigger('click')
        var pg_path = $('#mytinyDelete').attr('ajax_path')
        deletePermissionGroup(pg_path)
      });
      $('#deleteCancel').click( function() {
        $('a.close-reveal-modal').trigger('click')
      });
  // }



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
  })

  $('#addOfficeButton').click(function() {
    clearValidationErrors()
    var office = $('#oname').val();
    office_new = {"name": office};
    $('a.close-reveal-modal').trigger('click');
    addOffice(office_new);
  });

  $('#addPermissionGroupButton').click(function() {
    clearValidationErrors()
    var permission_group = $('#pgname').val();
    permission_group_new = {"name": permission_group};
    $('a.close-reveal-modal').trigger('click');
    addPermissionGroup(permission_group_new);
  });
});

function changetoeditmode() {
  $( '.view' ).css( "display", "none" );
  $( '.edit' ).css( "display", "inherit" );
  $( "#description" ).attr({
    "contenteditable": "true"
    // "spellcheck": "false",
    // "style": "position: relative;"
  });
  $("#description").addClass("editable free-text");
  // $("#description").addClass("free-text");
  initializetinymce(".editable");
  $("#currentmode").text('Edit Mode');
}

function changetoviewmode() {
  $( '.edit' ).css( "display", "none" );
  $( '.view' ).css( "display", "inherit" );
  $( "#description" ).attr( "contenteditable", "false" );
  $("#description").removeClass("editable");
  $("#description").removeClass("free-text");
  $("#currentmode").text('Preview Mode');
}

function clearValidationErrors() {
  alert('hey inside clear validation errors')
  error_list_children = $('#error_list > li')
  error_list_children.remove();
  $('#error_list').hide();
  $('.alert-box').each( function() {
    $(this).find('.error_list').html('');
    $(this).find('.success_msg').html('');
    $(this).hide();
  });
}

function addValidationError( type, message ) {
  error_list = $('#error_list')
  error_list.append( '<li class="alert-box alert radius" data-alert>' + message + '<a class="close close-alert-box" href="#">x</a></li>'
  );
}

function showValidationErrors() {
  error_list_children = $('#error_list > li')
  errors_exist = false
  if (error_list_children.length > 0) {
    error_list.show();
    errors_exist = true
  }
  if ( errors_exist ) {
    window.scrollTo(0,0)
  }
  return errors_exist
}

function addSuccessMessage(type, message ) {
  $('.alert-box.' + type ).find('span.success_msg').append(message);
}
function showSuccessMessage() {
  success_exist = false
  $('.alert-box').each( function() {
    if ( $(this).find('span').html){
       type = $(this).find('success')
       $('.alert-box.' + type.selector).show().html_safe;
       success_exist = true
    }
  })
  if ( success_exist) {
    window.scrollTo(0,0)
  }
  return success_exist
}

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

// function createReport(report_object ) {
//   report_object_string = JSON.stringify(report_object)
//   $.ajax({
//      url : '/reports',
//      type: 'POST',
//      data: { "report": report_object_string},
//      dataType: 'json',
//      success: function (data) {
//       addSuccessMessage("success", "<b>Report " + report_object.name +   " successfully. Please wait for report Detail page display.</b>")
//       showSuccessMessage();
//       var new_report = true;
//       var url = escape('/reports/'+ report_object.name)
//       window.location = url;
//    },
//      error: function( xhr, ajaxOptions, thrownError) {
//      addValidationError( "alert", "Added Report, " +report_object.name+ ", has error: " + xhr.responseText)
//      showValidationErrors();
//    }
//   });

// }

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



function updateTerm( term_object ) {
  $.ajax({
    // console.log('inside ajax')

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
         console.log("success update term");
      },
      error: function( xhr, ajaxOptions, thrownError) {
         addValidationError( "alert", "Update term has errors: " + xhr.responseText);
         showValidationErrors(); 
        console.log("not success update term");
      }
  })

}

function createTerm( term_object ) {
  
  $.ajax({
     url : '/terms',
     type: 'POST',
     data: { "term": term_object },
     success: function (data) {
      console.log("success create term")
      addSuccessMessage("success", "<b>Term " + term_object.name +   " successfully. Please wait for Term Detail page display.</b>");
      showSuccessMessage();
      var url = escape('/terms/'+ term_object.name);
      window.location = url;
   },
     error: function( xhr, ajaxOptions, thrownError) {
     console.log("not success create term")
     addValidationError( "alert", "Added Term, " +term_object.name+ ", has error: " + xhr.responseText);
     showValidationErrors()
   }
  })

}

function addOffice( office_object ) {
  $.ajax({
     url : '/offices',
     type: 'POST',
     data: { "office": JSON.stringify(office_object)},
     dataType: 'json',
     success: function (data) {
      var url = escape('/offices/'+ office_object.name);
      window.location = url;
      addSuccessMessage("success", "<b>Office " + office_object.name +   " successfully. Please wait for Office Detail page display.</b>");
      showSuccessMessage();
     },
     error: function( xhr, ajaxOptions, thrownError) {
      addValidationError( "alert", "Added office, "+office_object.name+ ", has error: " + jQuery.parseJSON(xhr.responseText).message);
      showValidationErrors()
    }
  })
}

function addPermissionGroup( permission_group_object ) {
  $.ajax({
     url : '/permission_groups',
     type: 'POST',
     data: { "permission_group": permission_group_object },
     success: function (data) {
      var url = escape('/permission_groups/'+ permission_group_object.name);
      window.location = url;
      addSuccessMessage("success", "<b>Permission Group " + permission_group_object.name +   " successfully. Please wait for Permission Group Detail page display.</b>");
      showSuccessMessage();
     },
     error: function( xhr, ajaxOptions, thrownError) {
      addValidationError( "alert", "Added Permission Group, "+ permission_group_object.name+ ", has error: " + jQuery.parseJSON(xhr.responseText).message);
      showValidationErrors()
    }
  })
}

function updatePermissionGroupObject( permission_group_object ) {
  clearValidationErrors()
  tinymce.triggerSave();
  $('.editable').each( function() {
    id = $(this).attr('id');
    if ( id ) {
      p = tinymce.get(id).getContent()
      if (id == "name") {
        var StrippedString = p.replace(/(<([^>]+)>)/ig,"")
        p = StrippedString;
      }
      permission_group_object[id] = p;
    }
  });
  return permission_group_object;
}

function updatePermissionGroup( permission_group_object ) {
  $.ajax({
      url: permission_group_object.id,
      type: 'PUT',
      data: { "permission_group" : permission_group_object},
      success: function (data) {
        var url = escape(permission_group_object.name);
        window.location = url;
        addSuccessMessage("success", "<b>" + permission_group_object.name + "</b>" +  " updated successfully. " );
        showSuccessMessage();
      },
      error: function( xhr, ajaxOptions, thrownError) {
         addValidationError( "alert", "Update Office, <b>" + permission_group_object.name + "</b>  has errors: " + xhr.responseText);
         showValidationErrors();
      }
  });
}

function updateOfficeObject( office_object ) {
  clearValidationErrors()
  tinymce.triggerSave();
  console.log(office_object);
  $('.editable').each( function() {
    id = $(this).attr('id');
    if ( id ) {
      p = tinymce.get(id).getContent()
      if (id == "name") {
        var StrippedString = p.replace(/(<([^>]+)>)/ig,"")
        p = StrippedString;
      }
      console.log(p);
      console.log(id);
      office_object[id] = p;
    }

  });

  return office_object;
}



function updateOffice( office_object ) {

  $.ajax({
      url: office_object.id,
      type: 'PUT',
      data: {"officeJSON": JSON.stringify(office_object)},
      dataType: 'json',
      success: function (data) {
        var url = escape(office_object.name);
        window.location = url;
        addSuccessMessage("success", "<b>" + office_object.name + "</b>" +  " updated successfully. " );
        showSuccessMessage();

      },
      error: function( xhr, ajaxOptions, thrownError) {
         addValidationError( "alert", "Update Office, <b>" + office_object.name + "</b>  has errors: " + jQuery.parseJSON(xhr.responseText).message);
         showValidationErrors();
      }
  });

}


function deleteOffice( officeid ) {
    $.ajax({
      url:   officeid,
      type: 'DELETE',
      success: function(data, status, xhr){
        addSuccessMessage("success", "<b>" + data.message + ". Please wait for Offices display Page.</br>" )
        showSuccessMessage();
        var myHashLink = "browse/offices";
        window.location.href = '/' + myHashLink;
      },
      error: function(xhr, status, error) {
           //alert(xhr.responseText)
        addValidationError( "alert", "Delete Permission Groups has errors: " + jQuery.parseJSON(xhr.responseText).message);
        showValidationErrors()
      }
  });
}

function deletePermissionGroup( pg_path ) {
    $.ajax({
      url:   pg_path,
      type: 'DELETE',
      success: function(data, status, xhr){
        addSuccessMessage("success", "<b>" + data.message + ". Please wait for Permission Groups display Page.</br>" )
        showSuccessMessage();
        var myHashLink = "browse/permission_groups";
        window.location.href = '/users/myprofile';
      },
      error: function(xhr, status, error) {
           //alert(xhr.responseText)
        addValidationError( "alert", "Delete Permission Groups has errors: " + jQuery.parseJSON(xhr.responseText).message);
        showValidationErrors()
      }
  });
}

initializetinymce(".editable");

function initializetinymce(the_textarea_div_class) {
  tinymce.init({
    selector: "div" + the_textarea_div_class,
    relative_urls: false,
    inline: true,
    menubar: true,
    relative_urls: false,
    plugins: [
        "advlist autolink lists link image charmap print preview anchor",
        "searchreplace visualblocks code fullscreen",
        "insertdatetime media table contextmenu paste "
    ],
    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image|anchor"
  });
}