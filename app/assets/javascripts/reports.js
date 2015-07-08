$(".reports.show").ready(function() {  
  $('#createReportButton').click(function() {
    var rname = $('#rname').val();
    report_new = {
      "name": rname,
      "description": "",
      "report_type": "Tableau",
      "embedJSON" : "{\"width\": \"\",\"height\": \"\" ,\"name\": \"\"}"
    };
    $('a.close-reveal-modal').trigger('click');
    createReport(report_new);
    // new_report = true
  });
  $('#updateReportButton').click( function() {
    report_object = {}
    error_exist = false;
    clearValidationErrors();
    error_text = "";

    // role input
    // json_access_array = $('#role_input').select2('data');
    // add back in when ready for security roles
    // if (jQuery.isEmptyObject(json_access_array)){
    //   // alert('addValidationError for json_access_array');
    //   addValidationError( "alert", "You Must Select a Security Role");
    //   error_exist = true;
    // }

    // office input
    // selected_office = $('#office_owner').val();
    // add back in when ready for offices
    // if(jQuery.isEmptyObject( selected_office )) {
    //   error_exist = true;
    //   // alert('addValidationError for selected_office');
    //   addValidationError( "alert", "You Must Select an Office That Owns This Report");
    // }

    // type input
    // selected_type = $('#type').val();
    // add back in when ready to edit report type
    // if(jQuery.isEmptyObject( selected_type )) {
    //   error_exist = true;
    //   addValidationError( "alert", "You Must Select the Report Type");
    // }
    if( error_exist ) {
      showValidationErrors();
      return false;
    }
    updateReportObject(report_object);
    updateReport(report_object);
  });

  $('#deleteReportConfirm').click( function() {
    $('a.close-reveal-modal').trigger('click');
    deleteReport(null);
  });

  $('#deleteReportCancel').click( function() {
    $('a.close-reveal-modal').trigger('click');
  });

  function updateReportObject(report_object) {
    clearValidationErrors();
    tinymce.triggerSave();
    report_object["name"] = $('#name-edit').val();
    report_object['description'] = tinymce.get('description').getContent()
    // $('.editable').each(function() {
    //   id = $(this).attr('id');
    //   if ( id ) {
    //     p = tinymce.get(id).getContent()
    //     report_object[id] = p;
    //   }
    // })
    // report_object["embedJSON"] = "{\"width\": \""+w+"\", \"height\" : \"" + h+"\",\"name\":\""+ n+"\",\"tabs\":\""+t+"\"}"

    // TERMS //
    // report_object["terms"] = []
    // var term_array = []
    // var term_text = null;
    // json_term_array = $('#term_input').select2('data')
    // console.log("This is the json_term_array: " + json_term_array);
    // for (var j = 0; j < json_term_array.length; j++ ) {
    //   report_object["terms"].push( { name: json_term_array[j]["text"]} )
    //   var term_exists = false;
    //   if (term_array != null )  {
    //     for (var k=0; k<term_array.length; k++){
    //       if (json_term_array[j]["text"] == term_array[k]["name"])  {
    //         term_exists = true;
    //         break;
    //       }
    //     }
    //   }
    //   if (!term_exists){
    //     term_array.push({name: json_term_array[j]["text"]})
    //   }
    //   else{
    //     if (!term_text)
    //       term_text = json_term_array[j]["text"]
    //     else if (term_text.search( json_term_array[j]["text"]) < 0 ){
    //       term_text  += " , "+ json_term_array[j]["text"]
    //     }
    //   }
    // }

    // report_object["report_type"] = $('#type').val();

    // report_object["tableau_link"] = $('#tableaulink').val();
    // report_object["datasource"] = $('#datasource').val();

    // report office owner
    // report_object["offices"] = []
    // report_object["offices"].push( { name: selected_office, stake: "Responsible"} )

    // By default, we are setting write ability to true for all associated role nodes
    // report_object["allows_access_with"] = []
    // var access_array=[]
    // var access_text =null;
    // console.log(json_access_array);
    // for ( var j = 0; j < json_access_array.length; j++ ) {

    //   report_object["allows_access_with"].push( { name: json_access_array[j]["text"], allow_update_and_delete: true} )
    //   var access_exists = false;
    //   if (access_array !=null )  {
    //     for (var k=0; k<access_array.length; k++){
    //       if (json_access_array[j]["text"] == access_array[k]["name"])  {
    //         access_exists = true;
    //         break;
    //       }
    //     }
    //   }

    //   if (!access_exists){
    //     access_array.push({name: json_access_array[j]["text"]})
    //   }
    //   else{
    //     if (!access_text){
    //       access_text = json_access_array[j]["text"]
    //     }
    //     else if (access_text.search( json_access_array[j]["text"]) <0){
    //       access_text  += " , "+ json_access_array[j]["text"]
    //     }
    //   }
    // }
    return true;
  }

  function createReport( report_object ) {
    $.ajax({
      url : '/reports',
      type: 'POST',
      data: { "report": report_object },
      success: function (data) {
        console.log('success create report')
        addSuccessMessage("success", "<b>Report " + report_object.name +   " successfully. Please wait for report Detail page display.</b>")
        showSuccessMessage();
        var url = escape('/reports/'+ report_object.name)
        window.location = url;
      },
      error: function( xhr, ajaxOptions, thrownError) {
        console.log('non success create report')
        addValidationError( "alert", "Added Report, " +report_object.name+ ", has error: " + xhr.responseText)
        showValidationErrors()
      }
    });
  }
  function updateReport(report_object) {
    $.ajax({
      url: report_object.id,
      type: 'PUT',
      data: {'report': report_object },
      success: function (data) {
        console.log("succcess report")
        var url = escape(report_object.name);
        window.location.href = url;
        addSuccessMessage("success", "<b>" + report_object.name + "</b>" +  " updated successfully. " );
        showSuccessMessage();
      },
      error: function( xhr, ajaxOptions, thrownError) {
        console.log('non success report')
        addValidationError( "alert", "Update Report has errors: " + xhr.responseText);
        showValidationErrors();
      }
    })
  }
  function deleteReport( ) {
    $.ajax({
      url:  $('#mytinyDelete').attr('ajax_path'),
      type: 'DELETE',
      success: function(data, status, xhr){
        console.log('success report delete')
        addSuccessMessage("success", "<b>" + data.message + ". Please wait for Reports Page display.</br>" )
        showSuccessMessage();
        window.location.href = '/users/myprofile'
      },
      error: function(xhr, status, error) {
        window.location.href = '/users/myprofile'
        console.log('non success report delete')
        // addValidationError( "alert", "Report delete has errors: " + xhr.responseText);
        // showValidationErrors();
      }
    });
  }
});