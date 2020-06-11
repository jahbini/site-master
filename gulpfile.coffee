# Brunch-config.coffee meta file
#
_=require 'lodash'
path = require 'path'
fs = require 'fs'
Sites = require './sitedef.json'
autoprefixer = require('gulp-autoprefixer')
beautify = require('gulp-beautify')
#browserSync = require('browser-sync').create()
del = require('del')
gulp = require('gulp')
mergeStream = require('merge-stream')
nunjucks = require('gulp-nunjucks')
sass = require('gulp-sass')
inject = require('gulp-inject-string')
gulpInsert = require 'gulp-insert'
os = require('os')
pkg = require('./package.json')
browserify = require 'gulp-browserify'
coffee = require 'gulp-coffee'
coffeeify = require 'coffeeify'
concat = require 'gulp-concat'
debug = require 'gulp-debug'
rename = require 'gulp-rename'

through = require('through2')
tildify = require('tildify')
stringifyObject = require('stringify-object')
chalk = require('chalk')
objectAssign = require('object-assign')
plur = require('plur')
prop = chalk.blue

examine = (opts) ->
  opts = objectAssign({
    title: 'gulp-debug:'
    minimal: true
  }, opts)
  if process.argv.indexOf('--verbose') != -1
    opts.verbose = true
    opts.minimal = false
  count = 0
  through.obj ((file, enc, cb) ->
    full = '\n' + (if file.cwd then 'cwd:   ' + prop(tildify(file.cwd)) else '') + (if file.base then '\nbase:  ' + prop(tildify(file.base)) else '') + (if file.path then '\npath:  ' + prop(tildify(file.path)) else '') + (if file.stat and opts.verbose then '\nstat:  ' + prop(stringifyObject(file.stat, indent: '       ').replace(/[{}]/g, '').trim()) else '') + '\n'
    output = if opts.minimal then prop(path.relative(process.cwd(), file.path)) else full
    count++
    console.log opts.title + ' ' + output
    try
      data =eval file.contents.toString()
      file.extname ='.html'
    catch err
      nc = err.toString()
      data = nc |  "-------\n" | file.contents
    file.contents = Buffer.from data
    cb null, file
    return
  ), (cb) ->
    console.log opts.title + ' ' + chalk.green(count + ' ' + plur('item', count))
    cb()
    return
S={}
for aSite in Sites.results
  aSite.fields.siteId = aSite.id
  S[aSite.name] = aSite.fields
Sites = S


#console.log S
for site in ['stjohnsjim']
  exports[site + 'Html'] = do (site)->
    siteTemplate = fs.readFileSync "./sites/#{site}/templates/#{site}template.coffee"
    HalvallaCard = fs.readFileSync "./sites/#{site}/templates/card.coffee"
    console.log "Generating #{site}"
    gulp.src("./sites/#{site}/templates/**/*.coffee")
      .pipe gulpInsert.prepend HalvallaCard
      .pipe gulpInsert.prepend siteTemplate
      .pipe gulpInsert.append "\n\nreturn 'no' unless renderer? \nconsole.log 'hello'\nreturn (T.render (new renderer db).html)"
      .pipe coffee()
      .pipe examine()
      .pipe gulp.dest("newfiles/")
    return
  exports[site + 'Js'] = do (site)->
    gulp.src("./site-loader/app/initialize.coffee", read:false )
      .pipe browserify transform: ['coffeeify'], extensions: ['.coffee'], paths:['./node_modules',"./sites/#{site}/"]
      .pipe rename "assets/js/app.js"
      .pipe gulp.dest("newfiles/")
    gulp.src("./site-loader/node_modules/jquery/dist/jquery.js").pipe(rename "assets/js/vendor.js").pipe gulp.dest "newfiles/"
    return
  exports[site + 'Assets'] = do (site) ->
    gulp.src(["./sites/#{site}/payload-/assets/**/*", "./sites/#{site}/templates/**/*.jpg", "./sites/#{site}/templates/**/*.png" ])
      .pipe gulp.dest "newfiles/"
    return
  exports[site + 'Vender'] = do (site) ->
    gulp.src(["./sites/#{site}/payload-/assets/**/*", "./sites/#{site}/templates/**/*.jpg", "./sites/#{site}/templates/**/*.png" ])
      .pipe gulp.dest "newfiles/"
    return
  exports[site + 'Css'] = do (site) ->
    gulp.src(["./sites/#{site}/payload-/assets/**/*", "./sites/#{site}/templates/**/*.jpg", "./sites/#{site}/templates/**/*.png" ])
      .pipe gulp.dest "newfiles/"
    return
  exports[site] = do (site)->
    exports[site + "Js"]()
    exports[site + "Html"]()
    exports[site + "Vender"]()
    exports[site + "Css"]()
    return
  return

exports.default = exports.stjohnsjimVender

return
process.exit 0

siteName = process.env.SITE
if !siteName
  console.log "Must specify env on cmd line: SITE='' brunch ..."
  process.exit()
else
  console.log "Processing #{siteName} with brunch"
theSite =  Sites[siteName]
if !theSite
  console.log "invalid site #{siteName} -- Not in sites.coffee"
  process.exit()
theResult =
  # See http://brunch.io/#documentation for docs.
  paths:
    public: "domains/#{siteName}/public"
    watched:[
      "domains/#{siteName}/brunch-payload-"
      'vendor'
      'app'
      ]
  conventions:
    ignored: (path) -> /\.c9|\.git/.test path
    assets: /(css.fonts|assets)[\\/]/
  modules:
    autoRequire: css: [
      siteName
      "#{siteName}/brunch-payload-/#{siteName}"
      "payload-/#{siteName}"
    ],
    "css/vendor.css": [
      "normalize"
      "blaze"
      "ace-css"
      "basscss-grid"
      "bootstrap"
    ]
    nameCleaner: (path) =>
      c=path.replace /^app\//, ''
      c=c.replace ///^assets/#{siteName}///, ''
      c=c.replace ///^domains\////, ''
      c=c.replace ///#{siteName}[\/]brunch-payload-///,'payload-'
      console.log "path Cleaner: #{path} - #{c}" if path.match "nothing to see here"
      return c
  files:
    javascripts:
      joinTo:
        'assets/js/app.js': [/^app/,///domains/#{siteName}\/brunch-payload-/// ]
        'assets/js/vendor.js': (f)->
          pattern= ///vendor|bower_components|node_modules///
          #console.log pattern
          result = f.match pattern
          #console.log "matching #{f}: #{result}"
          return result


      order:
        after:  /helpers\//

    stylesheets:
      order:   # must use full names not anyMatch syntax
        before: "node_modules/blaze/scss/dist/blaze.min.css"
        after: [ "node_modules/ace-css/css/ace.css", "node_modules/basscss-grid/css/grid.css", "node_modules/bootstrap/dist/css/bootstrap.min.css"]
      joinTo:
        'assets/css/app.css': [/^app/,///domains\/#{siteName}\/brunch-payload-///]
        'assets/css/vendor.css': ///^vendor|^bower_components|^node_modules///

    templates:
      joinTo:
        'assets/js/app.js': /^app/
  conventions:
    vendor:
      ///(^bower_components|node_modules|vendor)[\/]///
  npm:
    enabled: true
    globals:
      loglevel: "loglevel"
      #mui: "mui"
      #_: "underscore"
      jQuery: "jquery"
      fontFaceObserver: 'font-face-observer'

    styles: {
      "blaze": ["scss/dist/blaze.min.css"]
      "bootstrap": ["dist/css/bootstrap.min.css"]
      "ace-css": [ "css/ace.css" ]
      "basscss-grid": [ "css/grid.css" ]
    }

  plugins:
    order: [ 'coffeescript', 'babel' ]
    uglify:
      ignored: /app.js/
    gzip:
      optimize: "optimize"
      paths:
        javascript: 'assets/js'
        stylesheet: 'assets/css'
      removeOriginalFiles: false
      renameGzipFilesToOriginalFiles: false
      
    babel:
      presets: [ 'latest', 'react']
      plugins:  [
#        ["babel-plugin-root-import",  rootPathPrefix: "" ]
#        ["minify-dead-code-elimination"]
      ] 
    scss:
      mode: 'ruby' # set to 'native' to force libsass
  server:
    noPushState: true
    stripSlashes: true

#console.log theResult
exports.config = theResult
