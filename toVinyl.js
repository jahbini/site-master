'use strict';
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var gutil = require('gulp-util');
var browserify = require('browserify');

module.exports = function(b) {
    if (!(b instanceof browserify)) {
          b = browserify.apply(null, arguments);
        }

    var bundle = b.bundle;

    b.bundle = function(name) {
          return bundle.call(b)
            .on('error', function(err) {
                      gutil.log(gutil.colors.red('Browserify error'), err.message);
                      gutil.beep();
                      this.end();
                    })
            .pipe(source(name))
            .pipe(buffer());
        };

    return b;
};
