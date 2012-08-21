#= require markdown-editor
#= require showdown
#= require jquery.autogrow
#= require bootstrap-modal
#require jquery.ui.selectable
#= require_self

window.init_textarea= ->
  
  $ ->

    #set textareas width same as live-preview
    #hidden textareas also must have explicit width for autogrow to work propperly
    $("textarea:not(.editor-body)").width $("textarea:visible").next('.live-preview').width()
    $("textarea:not(.editor-body)").autogrow()
    #must be last becuase selector
    $("textarea:not(.editor-body)").markdownEditor()


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


    
