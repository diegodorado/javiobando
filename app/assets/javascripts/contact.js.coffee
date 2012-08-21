root = exports ? window

class root.Contact
  height: 240
  speed: 300
  constructor: (@$el, @personal)->

    if @personal
      @$first = $('article:first') 
    else
      @$first = $('') #nothing

    @$el.on 'click','.cp-links a', (ev) =>
      ev.preventDefault()
      $t = $(ev.currentTarget)
      
      if $t.hasClass 'contact-link'
        if @contact()
          @close()
        else
          @show 'contact'

      if $t.hasClass 'portfolio-link'
        if @portfolio()
          @close()
        else
          @show 'portfolio'

      if $t.hasClass 'plus-sign'
        if @closed()
          @show 'contact'
        else
          @close()


  contact: ->
    @$el.hasClass 'contact-open'
  
  portfolio: ->
    @$el.hasClass 'portfolio-open'

  closed: ->
    not (@contact() or @portfolio())
 
  close: ->
    @$el.find('.contact, .portfolio').animate
      opacity: 0
    ,@speed, =>
      @$el.removeClass()
      @$first.animate
        marginTop: 0
      ,@speed
      @$el.find('.top').animate
        height: 0
      ,@speed

  show: (witch)->
    if @closed()
      @$el.addClass "#{witch}-open"
      @$first.animate
        marginTop: @height
      ,@speed
      @$el.find('.top').animate
        height: @height
      ,@speed, =>
        @$el.find(".#{witch}").animate
          opacity: 1
        ,@speed
    else
      @$el.find('.contact, .portfolio').animate
        opacity: 0
      ,@speed, =>
        @$el.removeClass().addClass "#{witch}-open"
        @$el.find(".#{witch}").animate
          opacity: 1
        ,@speed
  

