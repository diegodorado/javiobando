root = exports ? window

#slide class

class root.Slide
  speed: 700
  constructor: (@$el, @index)->
    @$el.addClass 'slide'
    @$el.css 'z-index', 10000 - @index
    @first = @index is 0
    @transparent = @first and @$el.is 'header'
    @last = @$el.is 'footer'
    @slideshow = @$el.hasClass 'ss'
    @movieframe = @$el.hasClass 'mf'
    @fullscreen = @$el.hasClass 'fs'
    
    @set_up_slideshow() if @slideshow
    @set_up_movieframes() if @movieframe
    @set_up_fullscreen() if @fullscreen


  setHeight: (@minHeight)->
    @height = @$el.height()

  prev: ->
    $li = @$el.find('.slideshow li.current').prev('li')
    animateSlide $li if $li.size() > 0
  next: ->
    $li = @$el.find('.slideshow li.current').next('li')
    animateSlide $li if $li.size() > 0



  scroll: (delta)->
    
    mt = parseInt(@$el.css('marginTop'), 10) + 50 * delta
    if mt > -100 and delta > 0
      return -1

    if @last and mt < -(@height - @minHeight)  and delta < 0
      #dont move if last and bottom reached
      return @snapBottom()


    if mt < -(@height - 100)  and delta < 0
      return 1
    
    #todo: return if cannot slide so much

    @$el.stop().animate
      marginTop: mt
    , @speed/2
    
    return 0


  slideUpQuiet: ->
    @$el.css
      marginTop: -@height

  slideDownQuiet: ->
    @$el.css
      marginTop: 0

  snapTop: (callback)->
    @$el.animate
      marginTop: 0
    , @speed, callback

  snapBottom: (callback)->
    @$el.animate
      marginTop: -(@height-@minHeight)
    , @speed, callback

  slideUp: (callback)->
    @$el.animate
      marginTop: -@height
    , @speed, callback
    

  slideDown: (callback)->
    @$el.animate
      marginTop: 0
    , @speed, callback



  set_up_fullscreen: ->

    aspectRatio = 900/600

    $(window).resize(=>
      wh = $(window).height()
      ww = $(window).width()
      @$el.find('.fullscreen').toggleClass "tall", (ww/wh) < aspectRatio
      top = (wh - ww/aspectRatio)/2
      top = 0 if top > 0
      left = (ww - wh*aspectRatio)/2
      left = 0 if left > 0
      @$el.find('.fullscreen img').css
        top: top
        left: left
    ).trigger "resize"














  set_up_movieframes: ->
    mf_play = (ev)->
      $nxt = $(@).find('img.up').next()
      $nxt = $(@).find('img:first') if $nxt.length is 0
      $(@).find('img').removeClass ' up'
      $nxt.addClass ' up'
      setTimeout (=>
        $(@).trigger 'mf:play'
      ), 75


        
    @$el.on 'mouseenter', '.img-wrapper', (ev)->
      $(@).off 'mf:play', mf_play
    @$el.on 'mouseleave', '.img-wrapper', (ev)->
      $(@).on('mf:play', mf_play).trigger 'mf:play'

    @$el.find('.img-wrapper').on('mf:play', mf_play).trigger 'mf:play'



  #selector must be a slideshow list item (li)
  animateSlide= (selector) ->
    ww = $(window).width()
    $li = $(selector)
    
    $ss = $li.closest('.slideshow')

    return if $ss.hasClass 'moving'

    #close data
    $ss.find('li.current .img-data').removeClass 'open'

    $ss.find('li').removeClass 'current'
    $li.addClass 'current'
    p =  $li.position()
    gap = parseInt((ww-$li.outerWidth(true))/2 , 10)

    #slide!
    $ss.addClass 'moving'
    $ss.find('ul').animate
      left: gap - p.left
    , 600, ->
      $ss.removeClass 'moving'

    #ss first and last classes
    $ss.toggleClass 'first', $li.prev().size() is 0
    $ss.removeClass 'next-hover' if $ss.hasClass 'first' #fix
    $ss.toggleClass 'last', $li.next().size() is 0

    #set arrows position
    $ss.find('.icon-right-arrow').css 'right', gap-8
    $ss.find('.icon-left-arrow').css 'left', gap-8

  set_up_slideshow: ->

    animateSlide @$el.find('li:first')

    total_height = @$el.find('.slideshow').height()
    #sets img margin to center them vertically
    @$el.find('li').each  ->
      $(@).css
        marginTop: (total_height - $(@).height())/2

    @$el.find('.slideshow').height total_height

    @$el.find('.slideshow').addClass 'ready not-played'


    #bind all click events with single delegation
    @$el.on 'click','li:not(.current) .img-wrapper, .img-data-handler, .icon-left-arrow, .icon-right-arrow', (ev) ->
      $t = $(ev.currentTarget)

      if $t.hasClass 'img-wrapper'
        animateSlide $t.closest('li')
      if $t.hasClass 'icon-left-arrow'
        animateSlide $t.closest('.slideshow').find('li.current').prev('li')
      if $t.hasClass 'icon-right-arrow'
        animateSlide $t.closest('.slideshow').find('li.current').next('li')
      if $t.hasClass 'img-data-handler'
        $data = $t.closest('.img-data')
        $dw = $data.find('.img-data-wrapper')
        $dw.animate 
          height: "toggle"
        , 200, ->
          $data.toggleClass 'open'

    #hover next slide behaviour
    @$el.on 'mouseenter','li:not(.current), .icon-right-arrow', (ev) ->
      $ss = $(ev.currentTarget).closest('.slideshow')
      $ss.addClass 'next-hover'
    @$el.on 'mouseleave','li:not(.current), .icon-right-arrow', (ev) ->
      $ss = $(ev.currentTarget).closest('.slideshow')
      $ss.removeClass 'next-hover'

