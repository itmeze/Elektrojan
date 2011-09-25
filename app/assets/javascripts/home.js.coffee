# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
#
window.EJ = {}
window.EJ.setWatermarks = () ->
    $('.watermark').each(
      ->
        $(this).watermark($(this).attr('-data-watermark'))
    )

jQuery ->
  $('select#report-type').live( 'change'
    ->
        $.post(
          "/home/display_form"
          report_type: $(this).val()
          callback = (response) ->
            $('#report-form').html response
            $('form#report').validate()
        )
  )
  EJ.setWatermarks()
  $(document).ajaxComplete(
    -> EJ.setWatermarks()
  )
