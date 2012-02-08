function s() {
    var args = Array.prototype.slice.call(arguments)
    var f = args.shift()
    f(seq.apply(null, args))
}

// Experiment: runs actions in sequence, fancy pants
// each action must be f(cb)
// cb = (err, stuff)
function seq(cb) {
    var actions = Array.prototype.slice.call(arguments, 0)

    if (actions.length == 1)
        return cb

    return function() {
        var args = Array.prototype.slice.call(arguments, 0)
        // console.log("CALLED INNER", args)
        err = args.shift()

        // console.log("IN SEQ CB", actions, args)
        var f = actions.shift()
        if (!f) return
        if (err) {
            // console.log("FOUND ERR", err)
            return actions[actions.length-1](err)
        }

        var innerCb 
        
        if(actions.length == 1)
            innerCb = actions[0] 

        else 
            innerCb = seq.apply(null, actions)
                      
        var fArgs = args.concat([innerCb])
        // console.log("CALLING", f, fArgs)
        f.apply(null, fArgs)

        // # if it is the last one, 
        // # the cb is special. It'll have an actual cb in it
        // # they all respond
    }
}

// takes a normal function, uses the return value and sends it back as the 1st argument of a callback
function tocb(f) {
    // return a function that takes the normal arguments + a cb, and send the res to the callback
    return function() {
        var args = Array.prototype.slice.call(arguments)
        var cb = args.pop()
        var res = f.apply(null, args)
        cb(null, res)
    }
}

exports.seq = seq
exports.s = s
exports.tocb = tocb
