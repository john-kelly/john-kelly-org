var http = require('http');

var content = '<html><body><p>Hello World</p></body></html>';

http.createServer(function(request, response) {
    response.end(content);
}).listen(8080, 'localhost');
