$(function() {
    var $templates = $("#templates")



    // Prices
    loadCosts()

    var $usCost = $("#cost .cost .us")
    var $localCost = $("#cost .cost .local")

    function loadCosts() {
        $.get('/pricerange/us', function(data) {
            $usCost.find(".min").text(data.min)
            $usCost.find(".max").text(data.max)
        })

        $.get('/pricerange/state/UT', function(data) {
            $localCost.find(".min").text(data.min)
            $localCost.find(".max").text(data.max)
        })

    }




    // Load List
    loadMris()

    var $list = $("#list .list")
    var $listRowTemplate = $("#templates .listRow")

    function loadMris() {
        $.get('/mris', function(mris) {
            setList(mris)
        })
    }

    function setList(mris) {
        // clear existing list rows
        $list.find(".listRow").remove()

        for (var i = 0; i < mris.length; i++) {
            var mri = mris[i]
            var $row = $listRowTemplate.clone()

            $row.find(".amount").text(mri.amount)
            $row.find(".city").text(mri.city)
            $row.find(".state").text(mri.state)
            $row.find(".doctor").text(mri.doctor)

            $list.append($row)
        }
    } 
})
