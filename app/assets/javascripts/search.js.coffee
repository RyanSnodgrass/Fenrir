# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



highlightSearchString = ->
  search_string = $('#search1').val()
  $('.do_highlight').highlight search_string
  return

displayLoading = ->
  $('#search_results_right').html '<div class=\'search_results_msg\'><img src=\'/assets/ajax-loader.gif\'></div>'
  return