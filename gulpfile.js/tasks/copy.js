const gulp = require('gulp');

const {
    globs,
    dest,
} = require('../config').copy;

gulp.task('copy', ['clean'], () => {
    return gulp.src(globs)
        .pipe(gulp.dest(dest));
});
