
$.fn.Article = ->
  _keynext = (e) ->
    e.preventDefault()
    $figure_children = _figureChildren()
    if $figure_children.length > 1
      _active_figure++
      if _active_figure < $figure_children.length
        $figure_children.each (i) ->
          if i is _active_figure
            $.Scroll.stop().animate
              scrollTop: HEIGHTS[_active].min + $(this).height() * i
            , 600, "easeOutQuart"
      else
        _active_figure = 0
        _next e
    else
      _active_figure = 0
      _next e
  _keyprev = (e) ->
    e.preventDefault()
    $figure_children = _figureChildren()
    if $figure_children.length > 1
      _active_figure--
      if _active_figure >= 0
        $figure_children.each (i) ->
          if i is _active_figure
            $.Scroll.stop().animate
              scrollTop: HEIGHTS[_active].min + $(this).height() * i
            , 600, "easeOutQuart"
      else
        _active_figure = 0
        _prev e
    else
      _active_figure = 0
      _prev e
  _next = (e) ->
    _active++
    _active = _articleLength - 1  if _active >= _articleLength
    e.preventDefault()
    _seek _active
  _prev = (e) ->
    _active--
    _active = 0  if _active < 0
    e.preventDefault()
    _seek _active
  _seek = (seek_index) ->
    $.Scroll.stop().animate
      scrollTop: HEIGHTS[seek_index].min
    , 600, "easeOutQuart"
  _figureChildren = ->
    $f = {}
    $parent.each (index) ->
      $f = $(this).find("figure").children()  if index is _active

    $f
  _resize = ->
    runningHeight = 0
    $parent.triggerHandler $.Events.RESIZE
    _setBodyHeight()
  _orientation = ->
    orientation = window.orientation
    $parent.triggerHandler $.Events.ORIENT, orientation
  _setBodyHeight = ->
    $.Body.css height: runningHeight  unless $.MobileDevice
  $parent = this
  HEIGHTS = new Array()
  runningHeight = 0
  _issue = $.Body.attr("data-issue")
  _articleLength = @length
  _active = 0
  _active_figure = 0
  $.Body.bind($.Events.ARTICLE_NEXT, _next).bind($.Events.ARTICLE_PREV, _prev).bind($.Events.KEY_DOWN, _keynext).bind $.Events.KEY_UP, _keyprev
  $.Window.bind "resize", _resize
  window.onorientationchange = _orientation
  @each (index) ->
    _size = ->
      _figureHeight = (if $figure then $figure.height() else 0)
      HEIGHTS[index] =
        min: runningHeight
        max: runningHeight + _height()

      runningHeight += _height()
      $figure.css height: _figureHeight
      $self.css
        height: _selfHeight()
        overflow: "hidden"
        zIndex: 1000 - _index
    _scroll = (e) ->
      sTop = $.Window.scrollTop()
      location = HEIGHTS[_index]
      vS = view_status(sTop)
      switch vS
        when "page"
          $self.css marginTop: -(sTop - (location.min + _figureHeight))
          $figure.css marginTop: -(sTop - location.min)
          $self.triggerHandler $.Events.ARTICLE_SCROLL, sTop - location.min
        when "inview"
          $figure.css marginTop: -(sTop - location.min)
          $self.css marginTop: 0  unless _view is vS
          $self.triggerHandler $.Events.ARTICLE_SCROLL, sTop - location.min
        when "above"
          unless _view is vS
            $figure.css marginTop: -_figureHeight - 25
            $self.css marginTop: -_height() - 25
            $self.triggerHandler $.Events.ARTICLE_SCROLL, sTop - location.min
        when "outofview"
          unless _view is vS
            $self.triggerHandler $.Events.ARTICLE_SCROLL, 0
            $figure.css marginTop: 0
            $self.css marginTop: 0
        else
          unless _view is vS
            $self.triggerHandler $.Events.ARTICLE_SCROLL, 0
            $figure.css marginTop: 0
            $self.css marginTop: 0
      _view = vS
    view_status = (sTop) ->
      location = HEIGHTS[_index]
      if sTop > location.min and sTop <= location.max
        $self.addClass "_inview"  unless $self.hasClass("_inview")
        if sTop >= location.min + _figureHeight
          return "page"
        else
          return "inview"
      else
        $self.removeClass "_inview"  if $self.hasClass("_inview")
      return "outofview"  if sTop <= location.min - $.Window.height()
      return "below"  if sTop <= location.min
      "above"  if sTop > location.max
    _selfHeight = ->
      sH = $.Window.height()
      sW = $.Window.width()
      return _fixHeight(_fixedHeight, sW, sH)  if _fixedHeight
      sH
    _height = ->
      winHeight = $.Window.height()
      sW = $.Window.width()
      return _fixHeight(_fixedHeight, sW)  if _fixedHeight
      _figureHeight + winHeight
    _fixHeight = (_fixedHeight, sW) ->
      return 1200  if _ratio * sW <= 1200
      return _ratio * sW  if _ratio * sW > 1200
      parseInt _fixedHeight
    _keyright = (e) ->
      e.preventDefault()
      if _active is index
        if $figure_children.length > 1
          _active_figure++
          if _active_figure < $figure_children.length
            $figure_children.each (i) ->
              if i is _active_figure
                $.Scroll.stop().animate
                  scrollTop: $(this).offset().top - 250
                , 600, "easeOutQuart"
          else
            _active_figure = 0
            setTimeout (->
              $.Body.triggerHandler $.Events.ARTICLE_NEXT
            ), 100
        else
          _active_figure = 0
          setTimeout (->
            $.Body.triggerHandler $.Events.ARTICLE_NEXT
          ), 100
    _keyleft = (e) ->
      e.preventDefault()
      if _active is index
        if $figure_children.length > 1
          _active_figure--
          if _active_figure >= 0
            $figure_children.each (i) ->
              if i is _active_figure
                $.Scroll.stop().animate
                  scrollTop: $(this).offset().top - 250
                , 600, "easeOutQuart"
          else
            _active_figure = 0
            setTimeout (->
              $.Body.triggerHandler $.Events.ARTICLE_PREV
            ), 100
        else
          _active_figure = 0
          setTimeout (->
            $.Body.triggerHandler $.Events.ARTICLE_PREV
          ), 100
    $self = $(this)
    $figure = $self.find("figure")
    $figure_children = $figure.children()
    _view = ""
    _active_figure = 0
    _index = index
    _fixedHeight = $self.attr("data-height")
    _figureHeight = (if $figure then $figure.height() else 0)
    _ratio = 1200 / 1440
    $parent.bind($.Events.RESIZE, _size)
    _size()
    $.Window.bind "scroll", _scroll

  _setBodyHeight()
  @


