#= require markdown-editor
#= require showdown
#= require jquery.autogrow
#= require bootstrap-modal
#require jquery.ui.selectable
#= require_self

set_things= ->
  
  tw = parseInt($('.has_many_association_type.photos_field .controls').width() * 0.94, 10)
  setTimeout (-> 
    #hack for nested rails admin control duplication
    $('.tab-pane.active .control-group.orientation_field .input-append:eq(1)').remove()

    #set textareas width same as live-preview
    #hidden textareas also must have explicit width for autogrow to work propperly
    $("form textarea").width tw
    $("form textarea").each ->
      $(this).markdownEditor()
    $("form textarea").autogrow()

  ), 500

window.init_textarea= ->
  $ ->
    set_things()

  $('.has_many_association_type.photos_field').on 'click', 'a.add_nested_fields', (ev)->
    set_things()

$ ->
  $("#markdown-editor-dialog").on "click",".btn-primary", (e) ->
    e.preventDefault()
    dialog = $("#markdown-editor-dialog")
    title = dialog.find(".title").val()
    url = dialog.find(".url").val()
    if url and title
      link = "[#{title}](#{url})"
      dialog.find(".title").val('')
      dialog.find(".url").val('')
      $.markdownEditor.executeAction(dialog.data("editor"), /([\s\S]*)/, link)

    dialog.modal('hide')


$ ->

  return 'do nothing0'
  $('#article_view_as + .filtering-select > .ra-filtering-select-input').on( 'change', (ev)->
    $(@).closest('fieldset').removeClass().addClass $('#article_view_as').val()
  ).trigger 'change'

  $("#selectable").selectable stop: ->
    result = $("#select-result").empty()
    $(".ui-selected", this).each ->
      index = $("#selectable li").index(this)
      result.append " #" + (index + 1)


    
