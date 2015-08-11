/**
 * router.js
 *
 * provides a means to respond to client requests to particular
 * endpoints, which are URIs (or paths).
 */

/**
 * TODO-LIST
 * - support dynamic paths. ex: /blog/:id
 * - more support for specific HTTP request methods. ex: GET, POST, etc
 * - registering multiple callbacks to the same path
 *     - currently will always just hit the first callback that was registered.
 */

/**
* KNOWN-BUGS
* - Potential non-intuitive silent errors could occur if user of module
*     registers multiple routes for the same regex.
*/

// Node API
const http = require('http');
const url = require('url');

/**
 * Maintains the inner state of the router module.
 *
 * A route is of the form:
 * {
 *     method: {String},
 *     path: {String},
 *     callback: {Function}
 * }
 * @type {Array}
 */
const routes = [];

/**
 * This function serves two purposes.
 * 1.) Contains all public API of this module.
 *  - All public methods and attributes are attached to this function. This
 *    function is the only thing being exported.
 *
 * 2.) Acts as the entry point for the module.
 * - Intended useage for the router is that it is registered as a callback for
 *   a Node HTTP.Server instance's request event.
 * - When the HTTP.Server request event is triggered, this function iterates
 *     over all of the registered routes, executes the FIRST that it matches on
 *     and then breaks out.
 *
 * @param {http.ClientRequest} req - Instance of a Node http.ClientRequest.
 * @param {http.ServerResponse} res - Instance of a Node http.ServerResponse.
 * @return {undefined} - undefined
 */
const router = (req, res) => {
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
        const regexPath = new RegExp(route.path);
        if (regexPath.test(reqPathName) && route.method === req.method) {
            route.callback(req, res);
            // break;
            return true;
        }
    });
};

/**
 * HTTP method constants converted to an object for O(1) lookup.
 */
router.METHODS = http.METHODS.reduce((methods, method) => {
    methods[method] = method;
    return methods;
}, {});

/**
 * Function to register a new route.
 *
 * @param {String} path - String path, corresponds to a URI endpoint on the
 *     server. Path is converted to regex and matched on the pathname of req
 *     when determining callback function to run.
 * @param {Function} callback - Function to call on (req, res) when `path`
 *     endpoint is hit.
 * @return {undefined} - undefined
 */
router.register = (path, callback, method=router.METHODS.GET) => {
    routes.push({
        path,
        callback,
        method,
    });
};

module.exports = router;
