const path = require('path');

const config = {};

const dist = 'dist';

config.clean = {
    dist: dist,
};

config.copy = {
    globs: [
        'src/**', // All of the files
        '!src/static/scripts/elm/**/', '!src/static/scripts/elm/', // .elm are built w/ elm.js
        './app.json', './package.json', './Procfile', // Add files for heroku
    ],
    dest: dist,
};

config.elm = {
    globs: ['src/static/scripts/elm/**'],
    dest: path.join(dist, '/static/scripts/elm/'),
};

module.exports = config;
