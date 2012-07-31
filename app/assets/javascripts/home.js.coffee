close_cp= (e)->
  e.preventDefault()
  $('header').removeClass 'contact-open'
  $('header').removeClass 'portfolio-open'
  $('article.first').css
    marginTop: 0

$ ->
  $('.cp-links .contact-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'contact-open'
    $('article.first').css
      marginTop: 220
  $('.portfolio-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'portfolio-open'
    $('article.first').css
      marginTop: 220
  $('.cp-links .plus-sign').bind 'click', close_cp


$ ->
  $('body.index header .inner .middle').height $(window).height() - 20
  $('article.full-bg').height $(window).height()



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
  , 1000, ->
    $ss.removeClass 'moving'

  #ss first and last classes
  $ss.toggleClass 'first', $li.prev().size() is 0
  $ss.removeClass 'next-hover' if $ss.hasClass 'first' #fix
  $ss.toggleClass 'last', $li.next().size() is 0

  #set arrows position
  $ss.find('.icon-right-arrow').css 'right', gap-8
  $ss.find('.icon-left-arrow').css 'left', gap-8

set_up_slideshows = ->
  $('.slideshow').each  ->
    $ss = $(@)


    animateSlide $ss.find('li:first')

    #sets img margin to center them vertically
    $ss.find('.img-wrapper').each  ->
      $(@).css
        marginTop: (900 - $(@).height())/2

    $ss.height $ss.height()
    $ss.addClass 'ready not-played'



  #bind all click events with single delegation
  $('.slideshow').on 'click','li:not(.current) .img-wrapper, .img-data-handler, .icon-left-arrow, .icon-right-arrow', (ev) ->
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
  $('.slideshow').on 'mouseenter','li:not(.current), .icon-right-arrow', (ev) ->
    $ss = $(ev.currentTarget).closest('.slideshow')
    $ss.addClass 'next-hover'
  $('.slideshow').on 'mouseleave','li:not(.current), .icon-right-arrow', (ev) ->
    $ss = $(ev.currentTarget).closest('.slideshow')
    $ss.removeClass 'next-hover'

items = []
sTop = 0
slides_selector = 'body > header, article, body > footer' 

set_up_slides= ->
  height = 0
  items = [] #empty array

  $(slides_selector).each  (i,el)->
    $el = $(el)
    h = $el.height()
    height += h
    p = $el.position()
    items[i] = 
      index: i
      height: h
      minTop: p.top
      maxTop: p.top + h
      el: $el #store the element
      marginTop: 0
  
    $el.css
      'z-index': 1000-i
  

  $(slides_selector).css 
    position: 'fixed'
    
  $('body').css
    height: height




above_items = ->
  ai = active_item()
  item for item in items when item.index < ai.index

active_item = ->
  r = item for item in items when item.minTop <= sTop <= item.maxTop
  r

below_items = ->
  ai = active_item()
  item for item in items when item.index > ai.index


log= (data) ->
  $('#debug').html data

bind_keyboard= ->
  $(document).on "keydown", (ev) ->
    key = (if ev.charCode then ev.charCode else (if ev.keyCode then ev.keyCode else 0))

    ev.preventDefault() if 37 <= key <= 40

    switch key
      when 32
        ev.preventDefault()
        console.log item.marginTop for item in items
      when 38
        #KEY_UP
        return if above_items().length is 0
        prev = above_items()[above_items().length-1]
        scroll_to_item prev
      when 40
        #KEY_DOWN
        return if below_items().length is 0
        next = below_items()[0]
        scroll_to_item next
      when 37
        #KEY_LEFT
        $li = active_item().el.find('.slideshow li.current').prev('li')
        animateSlide $li if $li.size() > 0
      when 39
        #KEY_RIGHT
        $li = active_item().el.find('.slideshow li.current').next('li')
        animateSlide $li if $li.size() > 0


bind_hands_click= ->

  $('.hand-down a').on 'click', (ev) ->
    ev.preventDefault()
    return if below_items().length is 0
    scroll_to_item below_items()[below_items().length-1]

  $('.hand-up a').on 'click', (ev) ->
    ev.preventDefault()
    scroll_to 0

scroll_to_item= (item)->
  scroll_to item.minTop

scroll_to= (top)->
  ai = active_item()

  for item in items
    if  item.index < ai.index
      mTop = -item.height #slide is below
    else if  item.index > ai.index
      mTop = 0 #slide is above
    else
      #active slide
      mTop = -(top-item.minTop)

    item.marginTop = mTop
    
    #css3 transitions
    item.el.css
      marginTop: mTop

  $('body,html').scrollTop(top)


bind_scroll= ->

  $('body').addClass 'no-scroll'
  
  $(window).bind "scroll", (ev) ->

    #$('body,html').scrollTop(0)
    #ev.preventDefault()
    
    return if $('body').hasClass('scrolling')

    #sets global sTop
    sTop = $(window).scrollTop()

    scroll_to sTop
  
    if $('header').hasClass('portfolio-open') or $('header').hasClass('contact-open')
      close_cp(ev)
      return false

        
        
bind_resize= ->
  $(window).on 'resize', (ev) ->
    return window.location.reload()
    return if $('body').hasClass 'resizing'
    $('body').addClass 'resizing'
    $(slides_selector).css 
      position: 'relative'


    setTimeout (->
      set_up_slides()
      $('body,html').animate({scrollTop: active_item().minTop}, 500)
      $('body').removeClass 'resizing'

    ), 1500



change_header= ->
  $('header').prependTo($('article:first'))


$ ->
  change_header()
  set_up_slideshows()
  set_up_slides()
  bind_keyboard()
  bind_hands_click()
  bind_scroll()
  #bind_resize()
  
  
