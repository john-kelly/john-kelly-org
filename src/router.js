/**
 * The router module is intended to me used as a singleton. Router objects can
 * not be instantiated. There is only one state, which is the state of the
 * module.
 */

// TODO support dynamic inputs for routes. ex: '/blog/:id'

const url = require('url');

/**
 * Maintains the inner state of the router module. All registered routes live
 * in this routes array.
 * Route is of the form:
 * {
 *     path: {String},
 *     callback: {Function}
 * }
 * @type {Array}
 */
const routes = [];

/**
 * TODO Document
 * Design decision: I made the router a function so that the api was nicer!
 * all of the public api is a method on the router function/object
 * @param {[type]} req - [description]
 * @param {[type]} rep - [description]
 * @return {[type]} - [description]
 */
const router = (req, rep) => {
    const reqPathName = url.parse(req.url).pathname;
    routes.some((route) => {
        if (route.regexPath.test(reqPathName)) {
            route.callback(req, rep);
            return true;
        }
    });
};

/**
 * TODO Document
 * @param {[type]} path - [description]
 * @param {Function} callback - [description]
 * @return {[type]} - [description]
 */
router.register = (path, callback) => {
    routes.push({
        regexPath: new RegExp(path),
        callback: callback,
    });
};

module.exports = router;
