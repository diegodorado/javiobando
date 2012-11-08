root = exports ? window

#app class
#handle slide-moves events

class root.App

  active_index: 0
  debug: false
  slides: []
  swaping: false
  
  constructor: ->
    @window = $(window)

  start: ->
    @bind_keyboard()
    @bind_hands_click()
    @bind_scroll()
    @setup_slides()
    @bind_and_trigger_resize()
    @contact = new Contact $('header'), $('body.home.index').size() > 0
    #open external links in new window
    $(document.links).filter( () -> @hostname != window.location.hostname).attr('target', '_blank')



  setup_slides: ->  
    #prepend header to first article for comercial section
    $('body.home.comercial header').prependTo($('article:first'))  
    $('body > header, article, body > footer').each (i, el)=>
      @slides.push new Slide $(el), i


  bind_keyboard: ->

    @window.on "keydown", (ev) =>
      key = (if ev.charCode then ev.charCode else (if ev.keyCode then ev.keyCode else 0))
      ev.preventDefault() if 35 <= key <= 40

      if @isFirst()
        unless @contact.closed() 
          @contact.close() 
          return

      switch key
        when 35 then @moveLast()            #FIN
        when 36 then @moveFirst()           #INICIO
        when 38 then @movePrev()            #KEY_UP
        when 40 then @moveNext()            #KEY_DOWN
        when 37 then @activeSlide().prev()  #KEY_LEFT
        when 39 then @activeSlide().next()  #KEY_RIGHT


  bind_hands_click: ->
    $('.hand-down a').on 'click', (ev) =>
      ev.preventDefault()
      @moveLast()

    $('.hand-up a').on 'click', (ev) =>
      ev.preventDefault()
      @moveFirst()
    
  bind_and_trigger_resize: ->
    resizeTimer = null
    #only call once every 250ms
    @window.on('resize', (ev) =>
      clearTimeout resizeTimer if resizeTimer
      resizeTimer = setTimeout (=> 
        wh = @window.height()
        $('body.home.index header .inner .middle').height wh - 20
        s.afterResize(wh, s.index<@active_index) for s in @slides
        #.... not very pretty....
      ), 250
    )
    
    
    src = $('#header-arrows .icon-arrows').css('backgroundImage').replace(/^url\(["']?/, '').replace(/["']?\)$/, '')
    if $.browser.msie
      src += "?" + new Date().getTime()

    $("<img />", {src:src}).bind 'load', () ->
      setTimeout (->
        $('body').removeClass 'loading'
      ), 1000 
      #$('body header').find('#header-arrows, .tab-link, .hand-down,  .cp-links').animate('opacity',1)

    @window.load =>
      #font fully loaded
      @window.trigger 'resize'

  #handles slides scroll
  bind_scroll: ->
    #see http://ejohn.org/blog/learning-from-twitter/

    wheelDelta = 0
    wheelTimer = null
    #wheel event is defered to collect delta sum on a single event
    @window.on 'mousewheel', (event, delta) =>
      wheelDelta += delta
      clearTimeout wheelTimer if wheelTimer
      wheelTimer = setTimeout (=> 
        @scroll wheelDelta
        wheelDelta = 0
      ), 150

  #utils functions
  activeSlide: ->
    @slides[@active_index]

  isFirst: ->
    @active_index is 0

  #move functions
  scroll: (delta)->
    return if @swaping
    
    if @isFirst()
      unless @contact.closed() 
        @contact.close() 
        return

    r = @activeSlide().scroll(delta)
    if r > 0
      @moveNext()
    if r < 0
      @movePrev()
  moveFirst: ->
    return if @swaping
    first = 0
    if @active_index is first
      @activeSlide().snapTop()
    else
      @swaping = true
      @activeSlide().snapTop =>
        @active_index = first
        if @activeSlide().transparent
          @slides[@active_index+1].slideDown =>
            @activeSlide().slideDown =>
              @swaping = false
              s.slideDownQuiet() for s in @slides
        else
          @activeSlide().slideDown =>
            @swaping = false
            s.slideDownQuiet() for s in @slides
  moveNext: ->
    return if @swaping
    return @activeSlide().snapBottom() if @activeSlide().shouldSnapBottom()
    return @moveLast() if @active_index >= @slides.length - 2
    @swaping = true
    @activeSlide().slideUp =>
      @active_index++
      @swaping = false
  movePrev: ->
    return if @swaping
    return @activeSlide().snapTop() if @activeSlide().shouldSnapTop()
    return @moveFirst() if @active_index <= 1
    @swaping = true
    @activeSlide().snapTop =>
      @active_index--
      @activeSlide().slideDown =>
        @swaping = false
  moveLast: ->
    return if @swaping

    last = @slides.length - 1
    if @active_index is last
      #already last
      @activeSlide().snapBottom()
    else
      @swaping = true

      if @activeSlide().transparent
        #go to bottom from transparent header..

        for s in @slides
          unless (s.index <= @active_index + 1) or s.last
            s.slideUpQuiet()

        @activeSlide().slideUp =>
          @active_index++
          @activeSlide().slideUp =>
            @swaping = false
            @active_index = last

      else      
        for s in @slides
          unless s.index is @active_index or s.last
            s.slideUpQuiet()

        @activeSlide().slideUp =>
          @swaping = false
          @active_index = last
    
