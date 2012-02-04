

app = require('../app')
should = require('should')
common = require('../lib/common')

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
    server = app.createServer()
    request_ = request.partial server

    describe 'post mri', ->
        it 'should post', (done) ->
            request_ "POST", "/mris", {}, {amount: 10, state: "UT", city: "Provo", doctor: "Mr Bob"}, (v, code) ->
                v.should.be.equal(200)
                done()

    describe 'get mris', ->
        it 'should get all mris', (done) ->
            request_ "GET", "/mris", {}, {}, (mris) ->
                mris.should.have.property('length')
                mris.length.should.be.within(1, 9999999999999)
                done()

    describe 'get mris by state', ->
        it 'should get some mris for utah', (done) ->
            request_ "GET", "/mris/state/:state", {state: "UT"}, {}, (mris) ->
                mris.should.have.property('length')
                mris.length.should.be.within(1, 9999999999999)
                done()
            






