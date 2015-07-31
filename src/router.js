/**
 * router.js
 *
 * provides a means to respond to client requests to particular
 * endpoints, which are URIs (or paths).
 */

/**
 * TODO-LIST
 * - support dynamic paths. ex: /blog/:id
 * - suport specific HTTP request methods. ex: GET, POST, etc
 * - registering multiple callbacks to the same path
 *     - currently will always just hit the first callback that was registered.
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
 * This function servers two purposes.
 * 1.) Contains all public API of this module.
 *  - All public methods and attributes are attached to this function. This
 *    function is the only thing being exported.
 *
 * 2.) Acts as the entry point for the module.
 * - Intended useage for the router is that it is registered as a callback for
 *   a Node HTTP.Server instance's request event.
 *
 * @param {http.ClientRequest} req - Instance of a Node http.ClientRequest.
 * @param {http.ServerResponse} rep - Instance of a Node http.ServerResponse.
 * @return {undefined} - undefined
 */
const router = (req, rep) => {
    const reqPathName = url.parse(req.url).pathname;
    /**
     * This acts like an Array.forEach but with break functionality. The
     * Array.some method tests whether some of the elements in the array return
     * true when passed to the callback fn. The method will "break" out of the
     * loop on the first element that returns true. Simply have the callback fn
     * return true when you want to break out of the loop and you've got an
     * Array.forEach with break.
     */
    routes.some((route) => {
        if (route.regexPath.test(reqPathName)) {
            route.callback(req, rep);
            return true;
        }
    });
};

/**
 * Function to register a new route.
 *
 * @param {String} path - String path to be converted to regex. Corresponds to
 *     a URI endpoint on the server.
 * @param {Function} callback - Function to call on (req, res) when `path`
 *     endpoint is hit.
 * @return {undefined} - undefined
 */
router.register = (path, callback) => {
    routes.push({
        regexPath: new RegExp(path),
        callback: callback,
    });
};

/**
 * There is no reason for the router to have arbitrary attributes. If a user of
 * this api wants to extend this module in some fashion, they can just wrap it
 * in their own object.
 * NOTE: Does it make sense to freeze all objects? ex: router.register?
 */
module.exports = Object.freeze(router);
