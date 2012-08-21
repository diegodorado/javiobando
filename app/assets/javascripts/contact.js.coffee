root = exports ? window

class root.Contact

  constructor: (@$el, @comercial)->

    @$el.on 'click','.cp-links a', (ev) =>
      ev.preventDefault()
      $t = $(ev.currentTarget)
      
      if $t.hasClass 'contact-link'
        if @contact()
          @close()
        else
          @open_contact()
      if $t.hasClass 'portfolio-link'
        if @portfolio()
          @close()
        else
          @open_portfolio()
      if $t.hasClass 'plus-sign'
        if @closed()
          @open_contact()
        else
          @close()



  contact: ->
    @$el.hasClass 'contact-open'
  
  portfolio: ->
    @$el.hasClass 'portfolio-open'

  closed: ->
    not (@contact() or @portfolio())

      @activeSlide().snapTop =>
        @active_index = first
        if @activeSlide().transparent
          @slides[@active_index+1].slideDown =>
            @activeSlide().slideDown =>
              @swaping = false
              s.slideDownQuiet() for s in @slides

  hide: ->
    return
    
  close: ->
    @$el.removeClass()
    @$el.find('.top').animate
      height: 0

  open_contact: ->
    @$el.addClass 'contact-open'
    @$el.find('.top').animate
      height: 300


  open_portfolio: ->
    @$el.addClass 'contact-open'
    @$el.find('.top').animate
      height: 300


  
close_cp= (e)->
  e.preventDefault()
  $('header').removeClass
  $('article:first').css
    marginTop: 0
  cp_closed = true

test = ->
  $('.cp-links .contact-link').bind 'click', (e) ->
    close_cp(e)
    $('article:first').css
      marginTop: 220
    cp_closed = false
  $('.portfolio-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'portfolio-open'
    $('article:first').css
      marginTop: 220
    cp_closed = false
