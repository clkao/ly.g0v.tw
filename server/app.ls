express = require \express
fs = require \fs

lyserver = (app) ->
  port = 3333

  defHandler = (res) ->
    console.log 'Default handler'
    fs.createReadStream '_public/index.html' .pipe res

  fbHandler = (res) ->
    console.log 'Facebook Crawler User Agent'
    res.render 'index.html', do
      mode: 'bot'

  handlerMap = do
    fb: fbHandler
    def: fbHandler #XXX: use fbHandler since we are still developing

  patternMap = do
    fb: /.*facebookexternalhitv.*/
    def: /.*/


  getReqHandler = (req) ->
    return handlerMap['def'] unless req.headers['user-agent']
    console.log req.headers['user-agent']
    for k, re of patternMap
      if req.headers['user-agent'].match re
        return handlerMap[k]

  app.engine '.html', require('ejs').__express
  app.set 'views', '_public'

  app.use '/js', express.static \_public/js
  app.use '/css', express.static \_public/css
  app.use '/data', express.static \_public/data
  app.use '/fonts', express.static \_public/fonts
  app.use '/img', express.static \_public/img

  app.use (req, res) ->
    handler = getReqHandler req
    handler res

  app.listen port, ->
    console.log "Running on port #port"

app = express!
lyserver app

