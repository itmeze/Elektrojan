window.EJ = {}
window.EJ.setWatermarks = () ->
    $('.watermark').each(
      ->
        $(this).watermark($(this).attr('-data-watermark'))
    )

jQuery ->
  EJ.setWatermarks()
  $(document).ajaxComplete(
    -> EJ.setWatermarks()
  )

  $('form#new_search_conditions')
    .bind("ajax:success", (event, data, status, xhr) ->
      $('#search-response').html(data)
    )
  $.datepicker.setDefaults( $.datepicker.regional[ "pl" ] )
  $('.datepicker').datepicker()
  $('form#new_search_conditions').submit()
