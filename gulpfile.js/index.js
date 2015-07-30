// NOTE Disable b/c we do not have access to es6 in this file.
/*eslint-disable*/
/*
  gulpfile.js
  ===========
  Rather than manage one giant configuration file responsible
  for creating multiple tasks, each task has been broken out into
  its own file in gulpfile.js/tasks. Any files in that directory get
  automatically required below.
  To add a new task, simply add a new task file that directory.
  gulpfile.js/tasks/default.js specifies the default set of tasks to run
  when you run `gulp`.
*/

// All subsequent files required by node with the extensions .es6, .es, .jsx
// and .js will be transformed by Babel.
require('babel/register');

var requireDir = require('require-dir');

// Require all tasks in gulp/tasks, including subfolders
requireDir('./tasks', {recurse: true});
