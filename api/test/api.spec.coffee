

app = require('../app')
should = require('should')
common = require('../lib/common')
mri = require('../model/mri')
mongo = require('mongodb-wrapper')

request = (app, method, path, params, body, cb) ->

    routes = app.lookup[method.toLowerCase()](path)
    route = routes[0].callbacks[0]

    req = 
        body: body
        params: params
        param: (p) -> req.params[p]

    res = 
        send: (args...) -> 
            if res.called then throw new Error "res.send called twice"
            res.called = true
            cb args...

    route req, res

m = 0

describe 'api', ->
    # override the database
    db = mongo.db("localhost", 27017, "test") 
    server = app.createServer db
    request_ = request.partial server

    describe 'setup', ->
        it 'should remove all mris', (done) ->
            mris = new mri.Mris(db)
            mris.remove({}, done)

    describe 'post mri', ->
        it 'should post', (done) ->

            mris = [ {amount: 10, state: "UT", city: "Provo", doctor: "Mr Bob"}
                   , {amount: 8, state: "UT", city: "Provo", doctor: "Mr Bob"} ]

            request_ "POST", "/mris", {}, mris[0], (v, code) ->
                v.should.be.equal(200)
                request_ "POST", "/mris", {}, mris[1], (v, code) ->
                    v.should.be.equal(200)
                    done()

    describe 'get mris', ->
        it 'should get all mris', (done) ->
            request_ "GET", "/mris", {}, {}, (mris) ->
                mris.should.have.property('length')
                mris.length.should.be.equal(2)
                mris[0].amount.should.be.equal(10)
                done()

        it 'should sort them mris', (done) ->
            request_ "GET", "/mris", {sort: "amount"}, {}, (mris) ->
                mris.should.have.property('length')
                mris.length.should.be.equal(2)
                mris[0].amount.should.be.equal(8)
                done()

    describe 'get mris by state', ->
        it 'should get some mris for utah', (done) ->
            request_ "GET", "/mris/state/:state", {state: "UT"}, {}, (mris) ->
                mris.should.have.property('length')
                mris.length.should.be.within(1, 9999999999999)
                done()
            






