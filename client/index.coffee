require 'jquery-waypoints/waypoints.js'
_ = require 'underscore'

setSlideHeight = ->
  $('.slide').height $(window).height()

setupWaypoints = ->
  $('#slide3').waypoint (dir) ->
    fn = (if dir is 'down' then 'add' else 'remove') + 'Class'
    $('#header-nav')[fn] 'is-active'


$ ->
  $(window).on 'resize', setSlideHeight
  setSlideHeight()
  setupWaypoints()