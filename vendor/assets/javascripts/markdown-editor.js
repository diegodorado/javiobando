//= require showdown

(function($) {

  // Private functions
  getSelectionPosition = function($field ) {
    if ($field.length) {
      var start = 0, end = 0
      var el = $field.get(0)

      if (typeof el.selectionStart == "number" &&
          typeof el.selectionEnd == "number") {
        start = el.selectionStart
        end = el.selectionEnd
      }
      else {
        var range = document.selection.createRange()
        var stored_range = range.duplicate()
        stored_range.moveToElementText( el )
        stored_range.setEndPoint( 'EndToEnd', range )
        start = stored_range.text.length - range.text.length
        end = start + range.text.length

        // so, uh, we're close, but we need to search for line breaks and
        // adjust the start/end points accordingly since IE counts them as
        // 2 characters in TextRange.
        var s = start
        var lb = 0
        var i

        for ( i=0; i < s; i++ )
          if (el.value.charAt(i).match(/\r/)) ++lb

        if (lb) {
          start = start - lb
          lb = 0
        }

        var e = end
        for (i=0; i < e; i++)
          if (el.value.charAt(i).match(/\r/) ) ++lb
        if (lb) end = end - lb
      }
      return {
          start: start,
          end: end
      }
    }
  }

  getSelection = function( $field ) {
    var selStr = ''
    var selPos

    if ($field.length) {
      selPos = getSelectionPosition($field)
      selStr = $field.val().substring(selPos.start, selPos.end)
      return selStr
    }
    return false
  }

  replaceSelection = function($field, replaceText, reselect, cursorOffset) {
    var selPos = getSelectionPosition($field)
    var fullStr = $field.val()
    var selectNew = true
    if (reselect === false) selectNew = false

    var scrollTop = null
    if ($field[0].scrollTop) scrollTop = $field[0].scrollTop

    $field.val(fullStr.substring(0, selPos.start) + replaceText + fullStr.substring(selPos.end))
    $field[0].focus()

    if (selectNew) {
      if ($field[0].setSelectionRange) {
        if (cursorOffset) {
          $field[0].setSelectionRange(selPos.start + cursorOffset, selPos.start + cursorOffset)
        } else {
          $field[0].setSelectionRange(selPos.start, selPos.start + replaceText.length)
        }
      } else if ($field[0].createTextRange) {
        var range = $field[0].createTextRange()
        range.collapse( true )
        if (cursorOffset) {
          range.moveEnd(selPos.start + cursorOffset)
          range.moveStart(selPos.start + cursorOffset)
        } else {
          range.moveEnd('character', selPos.start + replaceText.length)
          range.moveStart('character', selPos.start)
        }
        range.select()
      }
    }

    if (scrollTop) {
      // this jumps sometimes in FF
      $field[0].scrollTop = scrollTop
    }
  }

  selectWholeLine = function($field) {
    var selPos = getSelectionPosition( $field )
    var el = $field.get(0)
    var i
    for ( i=selPos.start-1; i >= 0; i-- )
      if ( el.value.charAt(i).match(/\n/) ) break
    i++
    $field[0].setSelectionRange(i, selPos.end)
  }

  // Public function
  $.markdownEditor = {}
  $.markdownEditor.executeAction = function($editor, search, replace, whole_line, append) {
    var textElement = $editor.find('textarea')
    if (whole_line) selectWholeLine(textElement)
    var txt = textElement.val()
    var selPos = getSelectionPosition(textElement)
    var selText = getSelection(textElement)
    var repText = selText
    var reselect = true
    var cursor = null

    if (search && replace) {
      repText = repText.replace(search, replace)
      // remove backreferences
      repText = repText.replace(/\$[\d]/g, '')
      if ( repText === '' ) {
        cursor = replace.indexOf('$1')

        repText = replace.replace( /\$[\d]/g, '' )
        if ( cursor == -1 ) cursor = Math.floor( replace.length / 2 )
      }
    }

    if (append) {
      if ( repText == selText )  reselect = false
      repText += append
    }
    if (repText) replaceSelection( textElement, repText, reselect, cursor)
    $editor.find(".editor-body").keyup()
  }

  addFunctionBar = function($field) {
    $field.before('\
      <div class="function-bar">\
        <div class="function-buttons">\
          <a href="#" class="function-bold function-button">\
            <span>Bold</span></a>\
          <a href="#" title="Link" class="function-link function-button">\
            <span>Link</span></a>\
          <a target="_blank" href="http://daringfireball.net/projects/markdown/syntax" title="Help" class="function-help function-button">\
            <span>Help</span></a>\
        </div>\
      </div>')
  }

  makeBindings = function($editor) {
    var converter = new Showdown.converter;
    $editor
    .delegate(".function-button[href='#']", "click", function(e){
      e.preventDefault();
    })
    .delegate(".function-bold","click", function() {
      $.markdownEditor.executeAction($editor, /([^\n]+)([\n\s]*)/g, "**$1**$2")
    })
    .delegate(".function-link", "click", function() {
      $("#markdown-editor-dialog").data("editor", $editor);
      $('#markdown-editor-dialog').modal();
    });

    $editor.find('.editor-body').keyup(function() {
      var txt = $editor.find('.editor-body').val()
      var html = converter.makeHtml(txt)
      $editor.find(".live-preview").html(html)
    })
    $editor.find(".editor-body").keyup()
  }

  // Jquery plugin
  var methods = {
    init: function(options) {
      result = this.each(function() {
        if ( options ) {
          $.extend( settings, options )
        }
        $(this).addClass('editor-body').wrap('<div class="editor" />');
        addFunctionBar($(this))
        $(this).after('<div class="live-preview" />');

        makeBindings($(this).closest(".editor"))
      })
      return result
    },
    addFunctionBar: function() {
      this.each(function() {
        addFunctionBar($(this))
      })
    }
  }


  $.fn.markdownEditor = function(method) {
    var settings = {
      'function-bar' : 'basic'
    }
    if (methods[method]) return methods[method].apply(this, Array.prototype.slice.call(arguments, 1))

    else if (typeof method === 'object' || ! method){
      if ($(this).hasClass('editor-body')) return ;
      return methods.init.apply( this, arguments )
    }
    else
      $.error('Method ' +  method + ' does not exist on jQuery.markdownEditor' )
  }

})(jQuery)
