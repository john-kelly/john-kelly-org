const gulp = require('gulp');
const del = require('del');

const {dest} = require('../config').clean;

gulp.task('clean', (cb) => {
    del([dest], cb);
});
