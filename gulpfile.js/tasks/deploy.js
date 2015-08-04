const fs = require('fs');
const path = require('path');

const del = require('del');
const gulp = require('gulp');

const copyTask = () => {
    // Empty out or create the deploy directory
    // TODO might make sense to make use of the cwd... That way we garuntee
    // that we are in the right directory
    del(['./deploy'], (err1) => {
        if (err1) {
            console.log(err1);
            return;
        }

        fs.mkdir('./deploy', (err2) => {
            if (err2) {
                console.log(err2);
                return;
            }
            fs.readdir('./src', (err3, filenames) => {
                if (err3) {
                    console.log(err3);
                    return;
                }
                filenames.forEach((filename) => {
                    fs.createReadStream(path.join('./src', filename))
                        .pipe(fs.createWriteStream(path.join('./deploy', filename)));
                });
            });
            fs.createReadStream('app.json')
                .pipe(fs.createWriteStream(path.join('./deploy', 'app.json')));

            fs.createReadStream('package.json')
                .pipe(fs.createWriteStream(path.join('./deploy', 'package.json')));

            fs.createReadStream('Procfile')
                .pipe(fs.createWriteStream(path.join('./deploy', 'Procfile')));
        });
    });
};

gulp.task('deploy', [], copyTask);
