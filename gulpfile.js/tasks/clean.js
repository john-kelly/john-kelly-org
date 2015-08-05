const gulp = require('gulp');
const del = require('del');

const {buildDirectory} = require('../config');

gulp.task('clean', (cb) => {
    del([
        buildDirectory,
    ], cb);
});
