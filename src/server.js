// Node API
const http = require('http');
const fs = require('fs');

// Personal API
const router = require('./router.js');

// Html Routes
router.register('/$', (req, res) => {
    fs.readFile('./src/index.html', (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Stylesheet Routes
router.register('/main.css$', (req, res) => {
    fs.readFile('./src/main.css', (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});
router.register('/normalize.css$', (req, res) => {
    fs.readFile('./src/normalize.css', (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Default Route
router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router).listen(8080, 'localhost');
