express = require 'express'

app = module.exports = express()
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.send 'Hello World'

app.listen port = process.env.PORT or 4000, ->
  console.log "Listening on #{port}"