$(document).ready(function(){
  $('#addPermissionGroupButton').click(function() {
    clearValidationErrors()
    var permission_group = $('#pgname').val();
    permission_group_new = {"name": permission_group};
    $('a.close-reveal-modal').trigger('click');
    addPermissionGroup(permission_group_new);
  });
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
});

$(".permission_groups.show").ready(function() {
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

  function updatePermissionGroup(permission_group_object) {
    $.ajax({
      url: permission_group_object.id,
      type: 'PUT',
      data: { "permission_group" : permission_group_object},
      success: function (data) {
        var url = escape(permission_group_object.name);
        window.location = url;
        addSuccessMessage("success", "<b>" + permission_group_object.name + "</b>" +  " updated successfully. ");
        showSuccessMessage();
      },
      error: function(xhr, ajaxOptions, thrownError) {
        addValidationError( "alert", "Update Office, <b>" + permission_group_object.name + "</b>  has errors: " + xhr.responseText);
        showValidationErrors();
      }
    });
  }
  
  function deletePermissionGroup(pg_path) {
    $.ajax({
      url:   pg_path,
      type: 'DELETE',
      success: function(data, status, xhr){
        addSuccessMessage("success", "<b>" + data.message + ". Please wait for Permission Groups display Page.</br>")
        showSuccessMessage();
        var myHashLink = "browse/permission_groups";
        window.location.href = '/users/myprofile';
      },
      error: function(xhr, status, error) {
        addValidationError("alert", "Delete Permission Groups has errors: " + jQuery.parseJSON(xhr.responseText).message);
        showValidationErrors()
      }
    });
  }
});