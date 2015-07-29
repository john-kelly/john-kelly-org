let fs = require('fs');
let http = require('http');
let url = require('url');

let router = require('./router.js');

router.register('/$', (req, res) => {
    fs.readFile('./src/index.html', function(err, data) {
        res.end(data);
    });
});

router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router)
    .listen(8080, 'localhost');

console.log('Server is doing things');
