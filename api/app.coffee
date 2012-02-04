

# Application Requirements
express = require('express')
connect = require('connect')
path = require('path')
mri = require("./model/mri")
mongo = require('mongodb-wrapper')

# CONTROLLERS
exports.createServer = ->

    app = express.createServer()
    
    db = mongo.db("localhost", 27017, "mh") 
    mris = new mri.Mris(db) 
    
    # Universal Configuration
    app.configure ->
        app.use connect.bodyParser()
        app.use connect.methodOverride()
        app.use express.static(__dirname + '/public') 
    
    # Development Configuration
    app.configure 'development', ->
    
    # Production Configuration
    app.configure 'production', ->
        process.on 'uncaughtException', ->
            process.exit 1  # change me

    app.get '/', (req, res) ->
        res.send "HI"
    
    app.get '/health', (req, res) ->
        res.send 200
    
    app.get '/pricerange/us', (req, res) ->
        mris.findAllStats (err, minMax) ->
            if err? then return res.send err, 500
            res.send minMax

    app.get '/pricerange/state/:state', (req, res) ->
        state = req.param 'state'
        mris.findStatsBystate state, (err, minMax) ->
            if err? then return res.send err, 500
            res.send minMax

    app.post '/mri', (req, res) ->
        m = new mri.Mri req.body

        # check for a bad mri
        if msg = m.invalid()
            return res.send (new Error(msg)), 400

        mris.save m, (err) ->
            if err? then return res.send err, 500
            res.send 200



    

    app

if module == require.main
    app = exports.createServer()
    app.listen 4001
