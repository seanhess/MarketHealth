
mongo = require('mongodb-wrapper')
common = require('../lib/common')

flow = require('../lib/flow')
list = require('../lib/list')
s = flow.s
seq = flow.seq
tocb = flow.tocb
map = list.map

ValidStates = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "AS", "GU", "MP", "PR", "VI", "FM", "MH", "PW", "AA", "AE", "AP", "CZ", "PI", "TT", "CM"]


# convert to standard format
class Mri 
    constructor: (doc) ->
        @amount = doc.amount if doc.amount
        @state = doc.state if doc.state
        @doctor = doc.doctor if doc.doctor
        @date = doc.date || Date.now()
        @city = doc.city if doc.state
        @comments = doc.comments if doc.comments

    invalid: ->
        if not @amount? then return "amount is required"
        if not (@state in ValidStates) then return "invalid state"
        if not @city? then return "city is required"
        if not @doctor? then return "doctor is required"
        if not @date? then return "date is required"
        # comments are not required
        false


class Mris
    constructor: (db) -> 
        db.collection('mris') # we don't have proxies, so you have to tell it the collection name
        db.mris extends Mris.prototype
        return db.mris

    # needs scale. 
    findStatsByState: (state, cb) ->
        @find({state: state}).toArray seq(convert, stats, cb)

    findAllStats: (cb) ->
        @find({}).toArray seq(convert, stats, cb)

    findAll: (sort, cb) ->
        @find({})
        .sort(toSort(sort))
        .toArray seq(convert, cb)

    findByState: (state, sort, cb) ->
        @find({state: state})
        .sort(toSort(sort))
        .toArray seq(convert, cb)

        # what this would normally look like
        # this.find({}).toArray (err, docs) ->
        #     if err? then return cb err
        #     mris = docs.map (doc) -> new Mri doc
        #     minMax = stats(docs)
        #     cb null, minMax




# converts docs to Mri instances, cb-style
convert = (docs, cb) -> cb null, docs.map toMri
toMri = (doc) -> new Mri doc
toSort = (field) -> 
    sort = {}
    if field? then sort[field] = 1
    sort

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
