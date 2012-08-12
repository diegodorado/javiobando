#see http://ejohn.org/blog/learning-from-twitter/
cp_closed = true

close_cp= (e)->
  e.preventDefault()
  $('header').removeClass 'contact-open'
  $('header').removeClass 'portfolio-open'
  $('article:first').css
    marginTop: 0
  cp_closed = true

$ ->
  $('.cp-links .contact-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'contact-open'
    $('article:first').css
      marginTop: 220
    cp_closed = false
  $('.portfolio-link').bind 'click', (e) ->
    close_cp(e)
    $('header').addClass 'portfolio-open'
    $('article:first').css
      marginTop: 220
    cp_closed = false
  $('.cp-links .plus-sign').bind 'click', close_cp

  
$ ->
  app = new App
  app.start()
  #set_up_slideshows()
  #bind_and_trigger_resize()
  #set_up_movieframes()
  #bind_keyboard()
  #bind_hands_click()
  #bind_scroll()
