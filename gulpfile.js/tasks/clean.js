const gulp = require('gulp');
const del = require('del');

const {dist} = require('../config').clean;

gulp.task('clean', (cb) => {
    del([dist], cb);
});
