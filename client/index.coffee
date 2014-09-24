require 'jquery-waypoints/waypoints.js'
_ = require 'underscore'

IS_IPHONE = navigator.userAgent.match(/iPhone/i)
IS_IPAD = navigator.userAgent.match(/iPad/i)

setupClickHeaderNav = ->
  $('#header-nav a').click (e) ->
    e.preventDefault()
    top = $("##{$(this).attr('href')}").offset().top + 90
    $('body, html').animate scrollTop: top

setupSlide1Arrow = ->
  $('#slide1-down-arrow').click ->
    $('body, html').animate scrollTop: $(window).height(), 800

halfwayInScreen = ->
  ($(window).height() * 0.5) - $(this).height() / 2

setupWaypoints = ->

  # Show nav
  $('#slide3').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $('#header-nav')[fn] 'is-active'
  , offset: -> -$(this).height() - 200

  # Slide reveal 93% of the wealth
  $('#slide2').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $(this)[fn] 'is-active'
  , offset: -> halfwayInScreen.call(this) + 150

  # Grow graph
  $("#slide4 svg rect[idx]").each ->
    $(this).data 'originalHeight', $(this).attr 'height'
  $('#slide4').waypoint (dir) ->
    for i in [0..4]
      fn = ($el) -> ->
        $el.animate(
          { x: $el.data('originalHeight') }
          {
            duration: 1000,
            easing: 'easeOutCubic'
            step: (now) ->
              if dir is 'down'
                $(this).attr 'height', $(this).data('originalHeight') - now
              else
                $(this).attr 'height', now
          }
        )
      if dir is 'down'
        setTimeout fn($("#slide4 svg rect[idx=\"#{i}\"]")), 50 * i
      else
        setTimeout fn($("#slide4 svg rect[idx=\"#{4 - i}\"]")), 50 * i
  , offset: halfwayInScreen

  # Topple scale
  $('#slide8').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $(this)[fn] 'is-active'
  , offset: halfwayInScreen

  # Show ipads
  $('#slide5, #slide7').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $(this).find('.ipads')[fn] 'is-active'
  , offset: halfwayInScreen

  # Slide reveal Enter Observer.com of the wealth
  $('#slide6').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $(this)[fn] 'is-active'
  , offset: halfwayInScreen

  # Animate grid
  $('#slide9').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $(this)[fn] 'is-active'
  , offset: halfwayInScreen

  # Fade in last frame
  $('#slide15').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $(this)[fn] 'is-active'
  , offset: halfwayInScreen
  
  # Hide nav
  $('#slide9 + .slide').waypoint (dir) ->
    fn = (if dir is 'down' then 'remove' else 'add') + 'Class'
    $('#header-nav')[fn] 'is-active'

setupBacktoTop = ->
  $('#backtotop').click ->
    $('body, html').animate scrollTop: 0, 1500

setSlideHeight = ->
  $('.slide').css 'min-height': $(window).height()

transitionBGStart = ->
  return if $(window).scrollTop() > $('#slide8').offset().top
  start = $('#slide3 h1').offset().top + 100
  end = $('#slide4').offset().top - ($(window).height() / 2)
  perc = (end - $(window).scrollTop()) / (end - start)
  val = Math.max (Math.round perc * 255), 0
  $('body').css
    background: "rgb(#{255 - val},#{255 - val},#{255 - val})"
    color: "rgb(#{val + 40},#{val + 40},#{val + 40})"

transitionBGEnd = ->
  return if $(window).scrollTop() < $('#slide8').offset().top
  start = $('#slide9').offset().top + ($(window).height() / 2)
  end = ($('#slide11').offset().top - $(window).height()) + 200
  perc = (end - $(window).scrollTop()) / (end - start)
  val = Math.round perc * 255
  $('body').css
    color: "rgb(#{255 - val},#{255 - val},#{255 - val})"
    background: "rgb(#{val},#{val},#{val})"

highlightNav = ->
  $("#header-nav a").removeClass 'is-active'
  for el, i in els = $('#header-nav a').toArray().reverse()
    return $(el).addClass('is-active') if i is els.length - 1
    id = $(els[i + 1]).attr 'href'
    if ($("##{id}").offset().top + $("##{id}").height()) + 100 < $(window).scrollTop()
      $(el).addClass 'is-active'
      break

adjustForIOS = ->
  $('.slide, .ipads').addClass 'is-active'
  $("#slide4 svg rect[idx]").each -> $(this).attr 'height', 0
  $('#slide1, #slide15').css height: $(window).height()
  $('#slide2').css height: $(window).height()

$ ->
  if IS_IPHONE or IS_IPAD
    adjustForIOS()
  else
    $(window).on 'resize', _.debounce setSlideHeight, 100
    $(window).on 'scroll', transitionBGStart
    $(window).on 'scroll', transitionBGEnd
    $(window).on 'scroll', highlightNav
    setSlideHeight()
    setupWaypoints()
  setupClickHeaderNav()
  setupSlide1Arrow()
  setupBacktoTop()
  $('#slide1').addClass 'is-active'