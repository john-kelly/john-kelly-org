const gulp = require('gulp');
const elm = require('gulp-elm');

const {
    globs,
    dest,
} = require('../config').elm;

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init', 'clean'], () => {
    return gulp.src(globs)
        .pipe(elm())
        .pipe(gulp.dest(dest));
});
