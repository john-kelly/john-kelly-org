/**
 * TODO-LIST
 * - transpile in build proccess instead babel-node.
 */

// Node API
const http = require('http');
const fs = require('fs');
const path = require('path');
const util = require('util');

// 3rd Party
const pg = require('pg');

// Personal API
const {localDbUrl} = require('./config.js');
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

// Db Test Route
router.register('/db$', (req, res) => {
    pg.connect(process.env.DATABASE_URL || localDbUrl, (err1, client, done) => {
        if (err1) {
            res.end(util.format('%j', err1));
        } else {
            client.query('SELECT * FROM test_table', (err2, result) => {
                done();
                if (err2) {
                    res.end(util.format('%j', err2));
                } else {
                    res.end(util.format('%j', result));
                }
            });
        }
    });
});

// Favicon Route
router.register('/favicon.ico$', (req, res) => {
    fs.readFile(path.join(__dirname, '/favicon.ico'), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Default Route
// FIXME
// As it currently stands, the order in which a route is tested is not
// garunteed, therefore, this could theoretically run first, which is not what
// we want. Default routes should be implemented as an edgecase OR there needs
// to be a mechanism to determine route priority.
router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router).listen(process.env.PORT || 8080);
