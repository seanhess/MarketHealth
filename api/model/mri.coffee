
mongo = require('mongodb-wrapper')
common = require('../lib/common')

flow = require('../lib/flow')
list = require('../lib/list')
s = flow.s
seq = flow.seq
tocb = flow.tocb
map = list.map

# convert to standard format
class Mri 
    constructor: (doc) ->
        @amount = doc.amount || 0

class Mris
    constructor: -> 
        db = mongo.db("localhost", 27017, "mh")
        db.collection('mris')
        # fancy way to force the collection to extend this class and keep its stuff
        db.mris.__proto__ = Mris.prototype 
        return db.mris

    statsState: (cb) ->
        @find({state: state}).toArray seq(convert, stats, cb) # loses its this operator

    stats: (cb) ->
        @find({}).toArray seq(convert, stats, cb) # loses its this operator


# converts docs to Mri instances, cb-stype
convert = (docs, cb) -> 
    cb null, map toMri, docs

toMri = (doc) -> new Mri doc

# Average the total 
stats = (docs, cb) ->
    min = 0
    max = 0
    for doc in docs
        if doc.amount? 
            if doc.amount < min
                min = doc.amount
            if doc.amount > max
                max = doc.amount

    cb null, {min: min, max: max}



exports.Mris = Mris
if module == require.main
    console.log("HI")
    mris = new exports.Mris() 
    mris.stats (err, res) ->
        console.log("DONE", err, res)

# Mris.prototype.averageScoreState = function(state, cb) {
#     run(c.find({state: state}).toArray, average, cb)
# }
# 
# 
# // I need to average the results
# 
# // needs to return a callback, that takes the argument, checks for errors
# function average(scores, cb) {
# 
# }
# 
# 
# function next(f, cb) {
#     return function(err, result) {
#         if (err) return cb(err)
#         f(result)
#     }
# }
# 
# Function.prototype.then = function(f) {
# 
# }
# 
# 
# // take a function to call
# // call it, intercept the callback
# 
# 
# exports.Mris = Mris
# 
# 
