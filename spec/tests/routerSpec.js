const http = require('http');

const router = require('../../src/router.js');

// `describe` defines a test suite.
describe('a router', () => {

    // Setup a server and register some basic routes.
    beforeAll(() => {
        http.createServer(router).listen(8080, 'localhost');
        router.register('/$', (req, res) => {
            res.end('index');
        });
        router.register('.', (req, res) => {
            res.end('404');
        });
    });

    // `it` defines a single test
    it('can register a route to /$', (done) => {
        // test does not end until `done` is called
        http.get('http://localhost:8080/',(res) => {
            let resData = '';
            res.on('data',(data) => {
                resData += data;
            });
            res.on('end', () => {
                expect(resData).toEqual('index');
                done();
            })
        });
    });

    it('can register a route to .', (done) => {
        http.get('http://localhost:8080/asdf',(res) => {
            let resData = '';
            res.on('data',(data) => {
                resData += data;
            });
            res.on('end', () => {
                expect(resData).toEqual('404');
                done();
            })
        });
    });

    it('can override a registered route', (done) => {
        router.register('/$', (req, res) => {
            res.end('index test 2');
        });

        http.get('http://localhost:8080/',(res) => {
            let resData = '';
            res.on('data',(data) => {
                resData += data;
            });
            res.on('end', () => {
                expect(resData).toEqual('index test 2');
                done();
            })
        });
    });
});
