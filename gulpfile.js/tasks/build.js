const gulp = require('gulp');

const {
    sourceFiles,
    buildDirectory,
    appJson,
    packageJson,
    procfile,
} = require('../config');

gulp.task('build', ['clean'], () => {
    return gulp.src([sourceFiles, appJson, packageJson, procfile])
        .pipe(gulp.dest(buildDirectory));
});
