/**
 * router.js provides a means to respond to client requests to particular
 * endpoints, which are URIs (or paths).
 */

/**
 * TODO-LIST
 * - support dynamic paths. ex: /blog/:id
 * - suport specific HTTP request methods. ex: GET, POST, etc
 */

// Node API
const url = require('url');

/**
 * Maintains the inner state of the router module. All registered routes live
 * in this routes array.
 *
 * A route is of the form:
 * {
 *     path: {RegExp},
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
    // NOTE Document this! So cool!
    routes.some((route) => {
        if (route.regexPath.test(reqPathName)) {
            route.callback(req, rep);
            return true;
        }
    });
};

/**
 * TODO Document
 * @param {String} path - [description]
 * @param {Function} callback - [description]
 * @return {undefined} - undefined
 */
// NOTE - thoughts on freezing functions? probably unecessary.
router.register = (path, callback) => {
    routes.push({
        regexPath: new RegExp(path),
        callback: callback,
    });
};

/**
 * We freeze because:
 * There is no reason for the router to have arbitrary attributes. If an user
 * of this api wants to extend this router in some fashion, they can just wrap
 * it in their own object! compostion vs interhitance!
 */
module.exports = Object.freeze(router);
