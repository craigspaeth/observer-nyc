require 'jquery-waypoints/waypoints.js'
_ = require 'underscore'

setupClickHeaderNav = ->
  $('#header-nav a').click ->
    $('body, html').animate scrollTop: $("##{$(this).attr('href')}").offset().top + 50
    false

setSlideHeight = ->
  $('.slide').css 'min-height': $(window).height()

setupWaypoints = ->
  $('#slide3').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $('#header-nav')[fn] 'is-active'
  $('#slide10 + .slide').waypoint (dir) ->
    fn = (if dir is 'down' then 'remove' else 'add') + 'Class'
    $('#header-nav')[fn] 'is-active'
  for i in [4..9]
    $('#slide' + i).waypoint ->
      $("#header-nav a").removeClass 'is-active'
      $("#header-nav [href='#{$(this).attr 'id'}']").addClass 'is-active'

transitionBGStart = ->
  return if $(window).scrollTop() > $('#slide9').offset().top
  start = $('#slide3 h1').offset().top - 200
  end = $('#slide4').offset().top - $(window).height()
  perc = (end - $(window).scrollTop()) / (end - start)
  val = Math.round perc * 255
  $('body').css
    background: "rgb(#{255 - val},#{255 - val},#{255 - val})"
    color: "rgb(#{val},#{val},#{val})"

transitionBGEnd = ->
  return if $(window).scrollTop() < $('#slide9').offset().top
  start = $('#slide10').offset().top + $('#slide10').height() + 300
  end = $('#slide11').offset().top - ($(window).height() / 2) + 300
  perc = (end - $(window).scrollTop()) / (end - start)
  val = Math.round perc * 255
  $('body').css
    color: "rgb(#{255 - val},#{255 - val},#{255 - val})"
    background: "rgb(#{val},#{val},#{val})"

$ ->
  $(window).on 'resize', setSlideHeight
  $(window).on 'scroll', transitionBGStart
  $(window).on 'scroll', transitionBGEnd
  setSlideHeight()
  setupWaypoints()
  setupClickHeaderNav()