
mongo = require('mongodb-wrapper')
common = require('../lib/common')

flow = require('../lib/flow')
s = flow.s
seq = flow.seq


class Mris
    constructor: -> 
        db = mongo.db("localhost", 27017, "mh")
        db.collection('mris')
        db.mris.__proto__ = Mris.prototype  # extend this class, still keep all collection functions
        return db.mris
exports.Mris = Mris

Mris.prototype.averageState = (cb) ->
    this.find({state: state}).toArray seq(avg, cb) # loses its this operator

Mris.prototype.average = (cb) ->
    this.find({}).toArray seq(avg, cb) # loses its this operator

avg = (docs, cb) ->
    total = 0
    num = 0
    for doc in docs
        if doc.amount?
            total += doc.amount
            num++
    cb null, total / num



if module == require.main
    console.log("HI")
    mris = new exports.Mris() 
    mris.average (err, res) ->
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
