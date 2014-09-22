express = require 'express'
env = require 'node-env-file'
path = require 'path'

# setup
env __dirname + '/.env'
app = module.exports = express()
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'
if 'development' is process.env.NODE_ENV
  app.use require('stylus').middleware
    src: __dirname + '/stylesheets'
    dest: __dirname + '/public'
  app.use require('browserify-dev-middleware')
    src: __dirname + '/client'
    transforms: [require('caching-coffeeify')]
app.use express.static __dirname + '/public'

# routes
app.get '/', (req, res) ->
  res.render 'index', userAgent: req.headers['user-agent']

# start
app.listen port = process.env.PORT or 4000, ->
  console.log "Listening on #{port}"