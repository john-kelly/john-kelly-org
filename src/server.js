// Node API
const http = require('http');
const fs = require('fs');

// Personal API
const router = require('./router.js');

router.register('/$', (req, res) => {
    fs.readFile('./src/index.html', (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router).listen(8080, 'localhost');
