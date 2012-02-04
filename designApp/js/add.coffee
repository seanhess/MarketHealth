$ ->
  # // When the form submits, serialize the form and post it to /mris
  $("#add-results-form").submit (e) ->
    e.preventDefault()
    data = $("#add-results-form").serializeObject()
    mh.map.locationForAddress "#{data.city}, #{data.state}", (location) ->
      data.location = location
      p = $.post("/mris", data)
      p.done (r) ->
        alert("Success. You are a worthwhile human being.")
      p.fail (f) ->
        $("#add-errors").show()
        $("#add-errors span").text(JSON.parse(f.responseText).error)
