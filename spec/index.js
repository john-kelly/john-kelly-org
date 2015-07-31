// NOTE Disable b/c we do not have access to es6 in this file.
/*eslint-disable*/

// All subsequent files required by node with the extensions .es6, .es, .jsx
// and .js will be transformed by Babel.
require('babel/register');

var requireDir = require('require-dir');

// Require all tasks in spec/tests, including subfolders
requireDir('./tests', {recurse: true});
