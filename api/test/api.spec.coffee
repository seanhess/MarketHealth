

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
            request_ "POST", "/mri", {}, {amount: 10, state: "UT", city: "Provo", doctor: "Mr Bob"}, (v, code) ->
                v.should.be.equal(200)
                done()
            






