

# Application Requirements
express = require('express')
connect = require('connect')
path = require('path')
mri = require("./model/mri")

# CONTROLLERS
exports.createServer = ->

    app = express.createServer()
    
    mris = new mri.Mris() 
    
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
    
    app.get '/health', (req, res) ->
        res.send(200)
    
    app.get '/', (req, res) ->
        mris.average ->
        res.send 200
    
    app.get '/test/views', (req, res) ->
        res.render 'test', {something:"HI"}
    
    app

if module == require.main
    app = exports.createServer()
    app.listen 4001
