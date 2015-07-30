const fs = require('fs');
const http = require('http');

const router = require('./router.js');

router.register('/$', (req, res) => {
    fs.readFile('./src/index.html', (err, data) => {
        if (err) {
            // TODO something.
            return;
        }
        res.end(data);
    });
});

router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router)
    .listen(8080, 'localhost');

console.log('Server is doing things');
