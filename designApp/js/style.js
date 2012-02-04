$(function() {
    var $btn = $('button.add')
    console.log($btn)


    // really, I want to wait until certain things are loaded instead

    animateMachine(function() {
        animateAllRows()
    })


    function animateMachine(cb) {
        var $stripe = $("#stripe")
        var $machine = $stripe.find(".machine")
        var $h1 = $stripe.find("h1")

        var $bubbles = $stripe.find(".bubbles")
        var $bubble = $stripe.find(".bubble")
        var $bubbleText = $stripe.find(".bubble .text")

        $machine.addClass("place")
        $h1.addClass("place")
        $machine.cssTransitionEnd(function() {

            $bubbles.addClass('place')
            $bubbles.cssTransitionEnd(function() {
                $bubble.addClass('place')
                $bubble.cssTransitionEnd(function() {
                    $bubbleText.addClass('place')

                })
            })

            cb()

        })
    }


    function animateAllRows() {
        var itemsToLoad = $(".animateLoad").toArray()
        function animateNext() {
            var current = itemsToLoad.shift()
            if (!current) return
            $(current).addClass('loaded')
            $(current).cssTransitionEnd(function() {
                animateNext()
            })
        }
        animateNext()
    }
})


jQuery.fn.cssTransitionEnd = function(cb) {

    var current = this.get(0)

    current.addEventListener( 'webkitTransitionEnd', onTransitionEnd, false );
    current.addEventListener( 'transitionend', onTransitionEnd, false );
    current.addEventListener( 'OTransitionEnd', onTransitionEnd, false );

    function onTransitionEnd() {
        if (cb) cb()
        cb = null
    }
}
