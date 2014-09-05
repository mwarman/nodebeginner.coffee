querystring = require 'querystring'
fs = require 'fs'
formidable = require 'formidable'

start = (request, response) ->
  console.log "Request handler 'start' was called."
  
  markup = '<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF=8"/>
    </head>
    <body>
    <form action="/upload" enctype="multipart/form-data" method="post">
    <input type="file" name="upload">
    <input type="submit" value="Upload"/>
    </form>
    </body>
    </html>'
  
  response.writeHead 200, {'Content-Type': 'text/html'}
  response.write markup
  response.end()


upload = (request, response) ->
  console.log "Request handler 'upload' was called."
  
  form = new formidable.IncomingForm()
  console.log "about to parse"
  form.parse request, (error, fields, files) ->
    console.log "parsing done"
    console.log "fields: " + JSON.stringify(fields)
    console.log "files:  " + JSON.stringify(files)
    
    fs.rename files.upload.path, '/tmp/test.png', (error) ->
      if error
        fs.unlink '/tmp/test.png'
        fs.rename files.upload.path, '/tmp/test.png'

    response.writeHead 200, {'Content-Type': 'text/html'}
    response.write 'received image:<br/>'
    response.write '<img src="/show"/>'
    response.end()


show = (request, response) ->
  console.log "Request handler 'show' was called."
  response.writeHead 200, {'Content-Type': 'image/png'}
  fs.createReadStream('/tmp/test.png').pipe response


exports.start = start
exports.upload = upload
exports.show = show
