

# Application Requirements
express = require('express')
connect = require('connect')
path = require('path')
mri = require("./model/mri")
mongo = require('mongodb-wrapper')

# the jsonp middleware didn't work. Not compatible with latest express?
# jsonp = require('connect-jsonp')

# CONTROLLERS
exports.createServer = (db) ->

    app = express.createServer()
    
    db ?= mongo.db("localhost", 27017, "mh") 
    mris = new mri.Mris(db) 

    public = path.join __dirname, "public"
    
    # Universal Configuration
    app.configure ->
        app.use connect.bodyParser()
        app.use connect.methodOverride()
        # app.use jsonp() 
        app.use express.static public
    
    # Development Configuration
    app.configure 'development', ->
    
    # Production Configuration
    app.configure 'production', ->
        process.on 'uncaughtException', ->
            process.exit 1  # change me

    app.get '/health', (req, res) ->
        res.send 200
    
    app.get '/pricerange/us', (req, res) ->
        mris.findAllStats (err, minMax) ->
            if err? then return res.send err, 500
            res.send minMax

    app.get '/pricerange/state/:state', (req, res) ->
        state = req.param 'state'
        mris.findStatsByState state, (err, minMax) ->
            if err? then return res.send err, 500
            res.send minMax

    app.post '/mris', (req, res) ->
        m = new mri.Mri req.body

        # check for a bad mri
        if msg = m.invalid()
            return res.send {error: msg}, 400

        mris.save m, (err, doc) ->
            if err? then return res.send err, 500
            res.send 200

    app.get '/mris', (req, res) ->
        sort = req.param 'sort'
        mris.findAll sort, (err, mris) ->
            if err? then return res.send err, 500
            res.send mris

    app.get '/mris/state/:state', (req, res) ->
        state = req.param 'state'
        sort = req.param 'sort'
        mris.findByState state, sort, (err, mris) ->
            if err? then return res.send err, 500
            res.send mris

    # serve .html files from the public folder
    app.get '/', (req, res) ->
        res.sendfile path.join public, "default.html"

    app.get '/:file', (req, res) ->
        file = req.param "file"
        res.sendfile path.join public, file + ".html"
    

    # need to combine sort with 

    app

if module == require.main
    app = exports.createServer()
    app.listen 4001
