require 'jquery-waypoints/waypoints.js'
_ = require 'underscore'

setupClickHeaderNav = ->
  $('#header-nav a').click (e) ->
    e.preventDefault()
    top = $("##{$(this).attr('href')}").offset().top
    top += if $(window).scrollTop() > top then -50 else 50
    $('body, html').animate scrollTop: top

setupSlide1Arrow = ->
  $('#slide1-down-arrow').click ->
    $('body, html').animate scrollTop: $(window).height(), 800

setupWaypoints = ->

  # Slide reveal 93% of the wealth
  $('#slide2').waypoint (dir) ->
    $(this).addClass 'is-active'
  , offset: '30%'

  # Show nav
  $('#slide3').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $('#header-nav')[fn] 'is-active'

  # Grow graph
  $('#slide4').waypoint (dir) ->
    for i in [0..4]
      fn = ($el) -> ->
        $el.animate(
          { height: $el.attr('height') }
          {
            duration: 15000,
            easing: 'easeOutQuad'
            step: (now) ->
              $(this).attr 'height', Math.max ($(this).attr('height') - now), 0
          }
        )
      setTimeout fn($("#slide4 svg rect[idx=\"#{i}\"]")), 80 * i
  
  # Show ipads
  $('#slide5, #slide7').waypoint (dir) ->
    $(this).find('.ipads').addClass 'is-active'
  , offset: '10%'

  # Slide reveal Enter Observer.com of the wealth
  $('#slide6').waypoint (dir) ->
    $(this).addClass 'is-active'
  , offset: '30%'

  # Animate grid
  $('#slide9').waypoint (dir) ->
    $(this).addClass 'is-active'
  , offset: '-20%' 

  # Fade in last frame
  $('#slide15').waypoint ->
    $(this).addClass 'is-active'
  , offset: '40%'

  # Hide nav
  $('#slide9 + .slide').waypoint (dir) ->
    fn = (if dir is 'down' then 'remove' else 'add') + 'Class'
    $('#header-nav')[fn] 'is-active'

  # Highlight nav
  for i in [4..9]
    $('#slide' + i).waypoint ->
      $("#header-nav a").removeClass 'is-active'
      $("#header-nav [href='#{$(this).attr 'id'}']").addClass 'is-active'

setSlideHeight = ->
  $('.slide').css 'min-height': $(window).height()

transitionBGStart = ->
  return if $(window).scrollTop() > $('#slide8').offset().top
  start = $('#slide3 h1').offset().top - 200
  end = $('#slide4').offset().top - $(window).height()
  perc = (end - $(window).scrollTop()) / (end - start)
  val = Math.max (Math.round perc * 255), 0
  $('body').css
    background: "rgb(#{255 - val},#{255 - val},#{255 - val})"
    color: "rgb(#{val + 40},#{val + 40},#{val + 40})"

transitionBGEnd = ->
  return if $(window).scrollTop() < $('#slide8').offset().top
  start = $('#slide9').offset().top + $('#slide9').height() + 300
  end = $('#slide11').offset().top - ($(window).height() / 2) + 300
  perc = (end - $(window).scrollTop()) / (end - start)
  val = Math.round perc * 255
  $('body').css
    color: "rgb(#{255 - val},#{255 - val},#{255 - val})"
    background: "rgb(#{val},#{val},#{val})"

$ ->
  $(window).on 'resize', _.debounce setSlideHeight, 100
  $(window).on 'scroll', transitionBGStart
  $(window).on 'scroll', transitionBGEnd
  setSlideHeight()
  setupWaypoints()
  setupClickHeaderNav()
  setupSlide1Arrow()
  $('#slide1').addClass 'is-active'
  setTimeout (-> $('body, html').scrollTop 0), 50