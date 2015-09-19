/**
 * TODO-LIST
 * - transpile in build proccess instead babel-node.
 */

// Node API
const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const util = require('util');

// 3rd Party
const pg = require('pg');

// Personal API
const {localDbUrl} = require('./config.js');
const router = require('./router.js');

// Html Routes
router.register('/$', (req, res) => {
    fs.readFile(path.join(__dirname, '/static/index.html'), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Static File Route
// TODO I am not sure if this makes the server vulnerable to relative path
// traversal... It appears on first attempts that urls like /static/../index.js
// actually just convert to /index.js. The "."s are not being preserved as "."
// literals, they are being interpreted as relative paths prior to hitting the
// server. I think we are safe.
router.register('/static/.+$', (req, res) => {
    const reqPathName = url.parse(req.url).pathname;
    fs.readFile(path.join(__dirname, reqPathName), (err, data) => {
        if (err) {
            res.end('500');
        }
        res.end(data);
    });
});

// Db Test Route
router.register('/api$', (req, res) => {
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

// Default Route
router.register('.', (req, res) => {
    res.end('404');
});

http.createServer(router).listen(process.env.PORT || 8080);
