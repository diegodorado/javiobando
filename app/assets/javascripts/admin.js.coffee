#= require markdown-editor
#= require showdown
#= require jquery.autogrow
#= require bootstrap-modal
#= require_self

window.init_textarea= ->
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
    
