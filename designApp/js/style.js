$(function() {
    var $btn = $('button.add')
    console.log($btn)


    // really, I want to wait until certain things are loaded instead

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
