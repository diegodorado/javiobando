close_cp= (e)->
  e.preventDefault()
  $('header').removeClass 'contact-open'
  $('header').removeClass 'portfolio-open'

$ ->
  $('.cp-links .contact-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'contact-open'
  $('.portfolio-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'portfolio-open'
  $('.cp-links .plus-sign').bind 'click', close_cp


$ ->
  $('body.index header').height $(window).height()

#selector must be a slideshow list item (li)
animateSlide= (selector) ->
  ww = $(window).width()
  $li = $(selector)
  
  $ss = $li.closest('.slideshow')


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



$ ->
  #set up slideshows
  $('.slideshow').each  ->
    $ss = $(@)


    animateSlide $ss.find('li:first')

    #sets img margin to center them vertically
    $ss.find('.img-wrapper').each  ->
      $(@).css
        marginTop: (900 - $(@).height())/2

    $ss.height $ss.height()
    $ss.addClass 'ready not-played'



  #bind all click events with delegation
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


