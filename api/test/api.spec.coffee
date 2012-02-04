

app = require('../app')
should = require('should')

describe 'api', ->
    describe 'post mri', ->

        server = app.createServer()

        it 'should post', (done) ->
            postMri = server.lookup.post('/mri')[0]

            req = {
                body: {amount: 10, state: "UT"}
            }

            res = {
                send: (err, res) ->
                    res.should.equal(200)
                    done()
            }

            postMri req, res






