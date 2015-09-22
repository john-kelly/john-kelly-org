const path = require('path');

const argv = require('yargs').argv;

const config = {};

// So we don't have to track changes during development.
const dest = argv.dev ? 'dev' : 'dist';

config.clean = {
    dest: dest,
};

config.copy = {
    globs: [
        'src/**', // All of the files
        '!src/static/scripts/elm/**/', '!src/static/scripts/elm/', // .elm are built w/ elm.js
        './app.json', './package.json', './Procfile', // Add files for heroku
    ],
    dest: dest,
};

config.elm = {
    globs: ['src/static/scripts/elm/**'],
    dest: path.join(dest, '/static/scripts/elm/'),
};

module.exports = config;
