# namespace for functions
window.mh = {}

$ ->
  # this only goes one level deep
  $.fn.serializeObject = ->
    obj = {}
    $.each @serializeArray(), ->
      obj[@name] = @value
    obj
