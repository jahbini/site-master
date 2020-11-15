gulp = require('gulp')
const pfs = function(stream) { return ( new Promise( function (resolve, reject) {
      stream.on('finish', resolve);
      stream.on('end', resolve); // unsure if should use finish or end
      stream.on('error', reject);
}))};

pfs(
      gulp.src(getSrcFiles())
          .pipe(dostuff)
          .pipe(dostuff2)
          .dest('temp')
).then(function () {return  pfs(
      gulp.src('temp/**')
          .pipe(mySubstitutions)
          .dest('temp')
)}
).then(function () {return  pfs(
      gulp.src('temp/**')
          .dest('dist')
)}).then(function() {
      console.log('done');
})

