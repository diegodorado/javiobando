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


$ ->
  ww = $(window).width()
  iw = $('.slideshow ul li:first').addClass('current').outerWidth(true)
  il = parseInt(ww/2 - iw/2 , 10)
  $('.slideshow ul').css 'left', il
  
  $('.slideshow ul li').bind 'click', (e) ->

    $('.slideshow ul li').removeClass 'current'
    $(@).addClass 'current'
    p =  $(@).position()

    ww = $(window).width()
    iw = $(@).outerWidth(true)
    il = parseInt(ww/2 - iw/2 , 10)

    l = il - p.left
    $('.slideshow ul').animate
      left: l

