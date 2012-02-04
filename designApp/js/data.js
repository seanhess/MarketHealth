$(function() {
    var $list = $("#list .list")

    $.get('/mris', function(mris) {
        console.log("MRIS", mris)

    })
})
