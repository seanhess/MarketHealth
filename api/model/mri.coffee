
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
        @state = doc.state

class Mris
    constructor: -> 
        db = mongo.db("localhost", 27017, "mh")
        db.collection('mris') # we don't have proxies, so you have to tell it the collection name
        db.mris extends Mris.prototype
        return db.mris

    # needs scale. 
    findStatsByState: (state, cb) ->
        @find({state: state}).toArray seq(convert, stats, cb)

    findAllStats: (cb) ->
        @find({}).toArray seq(convert, stats, cb)

        # what this would normally look like
        # this.find({}).toArray (err, docs) ->
        #     if err? then return cb err
        #     mris = docs.map (doc) -> new Mri doc
        #     minMax = stats(docs)
        #     cb null, minMax




# converts docs to Mri instances, cb-style
convert = (docs, cb) -> cb null, docs.map toMri
toMri = (doc) -> new Mri doc

# Average the total 
stats = (mris, cb) ->
    for mri in mris
        continue unless mri.amount?
        min = mri.amount if mri.amount < min || not min?
        max = mri.amount if mri.amount > max || not max?

    cb null, {min: min, max: max}

# {a} = {a: a} in coffeescript
exports extends {Mris, Mri}



if module == require.main
    mris = new exports.Mris() 
    mris.findAllStats (err, res) ->
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
