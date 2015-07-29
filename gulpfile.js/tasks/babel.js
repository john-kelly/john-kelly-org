// TODO build before deploy

// let gulp = require('gulp');
// let babel = require('gulp-babel');
// let sourcemaps = require('gulp-sourcemaps');
// let path = require('path');
//
// let paths = {
//     es6: 'src/**/*.js',
//     es5: 'build',
//     // Must be absolute or relative to source map
//     sourceRoot: path.join(__dirname, 'src'),
// };
//
// gulp.task('babel', () => {
//     return gulp.src(paths.es6)
//         .pipe(sourcemaps.init())
//         .pipe(babel())
//         .pipe(sourcemaps.write('.'), {sourceRoot: paths.sourceRoot})
//         .pipe(gulp.dest(paths.es5));
// });
