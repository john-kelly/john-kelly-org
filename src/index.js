/**
 * TODO-LIST
 * - transpile in build proccess instead babel-node.
 */

// Node API
const http = require('http');
const fs = require('fs');
const path = require('path');

// Personal API
const router = require('./router.js');

// Html Routes
router.register('/$', (req, res) => {
    fs.readFile(path.join(__dirname, '/index.html'), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Stylesheet Routes
router.register('/main.css$', (req, res) => {
    fs.readFile(path.join(__dirname, '/main.css'), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});
router.register('/normalize.css$', (req, res) => {
    fs.readFile(path.join(__dirname, '/normalize.css'), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});
router.register('/page-layout.css$', (req, res) => {
    fs.readFile(path.join(__dirname, '/page-layout.css'), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Default Route
// TODO this needs to be implemented differently.
// As it currently stands, the order in which a route is tested is not
// garunteed, therefore, this could theoretically run first, which is not what
// we want.
router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router).listen(process.env.PORT || 8080, 'localhost');
