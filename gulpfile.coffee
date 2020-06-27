# Brunch-config.coffee meta file
#
Backbone = require 'backbone'
_=require 'lodash'
path = require 'path'
fs = require 'fs'
Sites = require './sitedef.json'
autoprefixer = require('gulp-autoprefixer')
beautify = require('gulp-beautify')
#browserSync = require('browser-sync').create()
del = require('del')
gulp = require('gulp')
gulpAddSource = require 'gulp-add-src'
mergeStream = require('merge-stream')
nunjucks = require('gulp-nunjucks')
sass = require('gulp-sass')
inject = require('gulp-inject-string')
gulpInsert = require 'gulp-insert'
concat = require 'gulp-concat'
debug = require 'gulp-debug'
rename = require 'gulp-rename'

os = require('os')
pkg = require('./package.json')
# browserify stuff
browserify = require 'browserify'
#vinylify = require "vinylify"
source=require 'vinyl-source-stream'
buffer=require 'vinyl-buffer'
deamdify = require 'deamdify'
coffeeify = require 'coffeeify'
bpr= require 'browser-pack-register'
coffee = require 'gulp-coffee'
wrapCommonJS = require "gulp-wrap-commonjs"
requireJSSource =  fs.readFileSync "./site-loader/node_modules/commonjs-require-definition/require.js"

through = require('through2')
tildify = require('tildify')
stringifyObject = require('stringify-object')
chalk = require('chalk')
objectAssign = require('object-assign')
plur = require('plur')
prop = chalk.blue

DBModel = Backbone.Model.extend
  default:
    draft: true
DBColl = Backbone.Collection.extend
  model: DBModel
allDB = new DBColl()

examineBundle = (opts) ->
  opts = objectAssign({
    title: 'gulp-browserify-debug:'
    minimal: true
  }, opts)
  if process.argv.indexOf('--verbose') != -1
    opts.verbose = true
    opts.minimal = false
  count = 0
  through.obj ((file, enc, cb) ->
    full = '\n' + (if file.cwd then 'cwd:   ' + prop(tildify(file.cwd)) else '') + (if file.base then '\nbase:  ' + prop(tildify(file.base)) else '') + (if file.path then '\npath:  ' + prop(tildify(file.path)) else '') + (if file.stat and opts.verbose then '\nstat:  ' + prop(stringifyObject(file.stat, indent: '       ').replace(/[{}]/g, '').trim()) else '') + '\n'
    output = if opts.minimal then prop(path.relative(process.cwd(), file.path)) else full
    debugger
    count++
    console.log opts.title + ' ' + output
    console.log file.contents.toString()
    cb null, file
    return
  ), (cb) ->
    console.log opts.title + ' ' + chalk.green(count + ' ' + plur('item', count))
    cb()
    return

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
    debugger
    try
      raw = file.contents.toString()
      file.extname ='.html'
      data = eval raw
      data = JSON.parse data
      db=data.db
      html= data.html || ""
      #allDB.push db
    catch err
      nc = err.toString()
      data = nc |  "-------\n" | file.contents.toString()
    file.contents = Buffer(html)
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

toVinyl = (b) ->
  if !(b instanceof browserify)
    b = browserify.apply(null, arguments)
  bundle = b.bundle

  b.bundle = (name) ->
    if typeof name =='string'
      return bundle.call(b).on('error', (err) ->
        console.log "ERR in Module $name",err
        return
        ).pipe(source(name)).pipe buffer()

  b

bcp = fs.readFileSync(require.resolve('browserify-common-prelude/dist/bcp.js'), 'utf-8')
bpipeline = (fileIn,fileOut)->
  a=browserify fileIn,
      transform: ['coffeeify','deamdify']
      extensions: ['.coffee']
      debug:true
      paths:['./node_modules',"./sites/#{site}/"]
      prelude: "JAH bcp here"
  return a
#
#console.log S
for site in ['stjohnsjim']
  exports[site + 'Html'] = do (site)-> return ()->
    siteTemplate = fs.readFileSync "./sites/#{site}/templates/#{site}template.coffee"
    HalvallaCard = fs.readFileSync "./sites/#{site}/templates/card.coffee"
    console.log "Generating #{site}"
    gulp.src("./sites/#{site}/templates/**/*.coffee")
      .pipe gulpInsert.prepend HalvallaCard
      .pipe gulpInsert.prepend siteTemplate
      .pipe gulpInsert.append """
        debugger
        unless renderer?
          return JSON.stringify {db:false,html:''}
        t= (T.render (new renderer db).html)
        value= { db: db, html:t }
        return JSON.stringify(value)
        """
      .pipe coffee()
      .pipe examine()
      .pipe gulp.dest("newfiles/")
    return
  exports[site + 'Js'] = do (site)-> return ()->
    bb= browserify "./site-loader/app/initialize.coffee",
      transform: ['coffeeify','deamdify']
      extensions: ['.coffee']
      fullPaths: true
      paths:['./site-loader/node_modules','./site-loader/app',"./sites/#{site}","./sites/#{site}/payload-","./sites/#{site}/node_modules"]
      basedir: "/Users/jahbini/mar1on/site-master"
      prelude: "JAH bcp here"
      read:false
    bb.require './site-loader/app/initialize.coffee'
    xx= bb.pipeline.get 'pack'
    yy= xx.pop()
    xx.push bpr raw:true, prelude: requireJSSource.toString()
    #xx.push bpr raw:true
    b1= toVinyl bb
    b2= b1.bundle("assets/js/app.js")
      .pipe examineBundle verbose:true,minimal:false
      .pipe gulp.dest("newfiles/")
    gulp.src([
        "./site-loader/node_modules/jquery/dist/jquery.js"
        "./site-loader/node_modules/asap/asap.js"
      ])
     .pipe gulpAddSource.append './site-loader/node_modules/bootstrap/dist/js/bootstrap.js'
     .pipe gulpAddSource.append './site-loader/node_modules/backbone/backbone.js'
     .pipe gulpAddSource.append './site-loader/node_modules/base64-js/index.js'
     .pipe gulpAddSource.append './site-loader/node_modules/buffer/index.js'
     .pipe gulpAddSource.append './site-loader/node_modules/chroma-js/chroma.js'
     .pipe gulpAddSource.append './site-loader/node_modules/font-face-observer/src/dom.js'
     .pipe gulpAddSource.append './site-loader/node_modules/font-face-observer/src/observer.js'
     .pipe gulpAddSource.append './site-loader/node_modules/font-face-observer/src/ruler.js'
     .pipe gulpAddSource.append './site-loader/node_modules/halvalla/lib/halvalla-mithril.js'
     .pipe gulpAddSource.append './site-loader/node_modules/halvalla/lib/html-tags.js'
     .pipe gulpAddSource.append './site-loader/node_modules/halvalla/lib/name-mine.js'
     .pipe gulpAddSource.append './site-loader/node_modules/halvalla/lib/halvalla.js'
     .pipe gulpAddSource.append './site-loader/node_modules/halvalla/lib/teacup.js'
     .pipe gulpAddSource.append './site-loader/node_modules/ieee754/index.js'
     .pipe gulpAddSource.append './site-loader/node_modules/isarray/index.js'
     .pipe gulpAddSource.append './site-loader/node_modules/mithril/mithril.js'
     .pipe gulpAddSource.append './site-loader/node_modules/mss-js/mss.js'
     .pipe gulpAddSource.append './site-loader/node_modules/palx/dist/hue-name.js'
     .pipe gulpAddSource.append './site-loader/node_modules/palx/dist/index.js'
     .pipe gulpAddSource.append './site-loader/node_modules/process/browser.js'
     .pipe gulpAddSource.append './site-loader/node_modules/promise/index.js'
     .pipe gulpAddSource.append './site-loader/node_modules/promise/lib/node-extensions.js'
     .pipe gulpAddSource.append './site-loader/node_modules/promise/lib/es6-extensions.js'
     .pipe gulpAddSource.append './site-loader/node_modules/promise/lib/done.js'
     .pipe gulpAddSource.append './site-loader/node_modules/promise/lib/core.js'
     .pipe gulpAddSource.append './site-loader/node_modules/underscore/underscore.js'
     .pipe wrapCommonJS relativePath:"./site-loader/node_modules/"
     #.pipe examineBundle verbose:true,minimal:false
     #.pipe gulpAddSource.append './site-loader/node_modules/font-face-observer/src/*.js'
     .pipe(concat "assets/js/vendor.js")
     .pipe gulpInsert.prepend requireJSSource + ";"
     .pipe gulpInsert.append """
require.alias('./site-loader/node_modules/backbone/backbone.js','backbone');
require.alias('./site-loader/node_modules/base64-js/index.js','base64-js');
require.alias('./site-loader/node_modules/bootstrap/dist/js/bootstrap.js','bootstrap');
require.alias('./site-loader/node_modules/chroma-js/chroma.js','chroma-js');
require.alias('./site-loader/node_modules/font-face-observer/src/dom.js','dom');
require.alias('./site-loader/node_modules/font-face-observer/src/observer.js','observer');
require.alias('./site-loader/node_modules/font-face-observer/src/ruler.js','ruler');
require.alias('./site-loader/node_modules/halvalla/lib/halvalla-mithril.js','halvalla-mithril');
require.alias('./site-loader/node_modules/halvalla/lib/halvalla.js','halvalla');
require.alias('./site-loader/node_modules/halvalla/lib/teacup.js','teacup');
require.alias('./site-loader/node_modules/halvalla/lib/html-tags.js','html-tags');
require.alias('./site-loader/node_modules/halvalla/lib/name-mine.js','name-mine');
require.alias('./site-loader/node_modules/ieee754/index.js','ieee754');
require.alias('./site-loader/node_modules/isarray/index.js','isarray');
require.alias('./site-loader/node_modules/mithril/mithril.js','mithril');
require.alias('./site-loader/node_modules/mss-js/mss.js','mss-js');
require.alias('./site-loader/node_modules/palx/dist/hue-name.js','hue-name.js');
require.alias('./site-loader/node_modules/palx/dist/index.js','palx');
require.alias('./site-loader/node_modules/process/browser.js','process');
require.alias('./site-loader/node_modules/promise/index.js','promise');
require.alias('./site-loader/node_modules/underscore/underscore.js','underscore');
require.alias('./site-loader/node_modules/promise/index.js','promise');
require.alias('./site-loader/node_modules/buffer/index.js','buffer');
require.alias('jquery/dist/jquery.js','jquery');
require.alias('asap/asap.js','asap');
require.alias('asap/me.js','you');
require("jquery");
     """
     .pipe gulp.dest "newfiles/"
    return
  exports[site + 'Assets'] = do (site) -> return ()->
    gulp.src(["./sites/#{site}/payload-/assets/**/*", "./sites/#{site}/templates/**/*.jpg", "./sites/#{site}/templates/**/*.png" ])
      .pipe gulp.dest "newfiles/"
    return
  exports[site + 'Css'] = do (site) -> return ()->
    gulp.src([
        "./site-loader/node_modules/blaze/scss/dist/blaze.min.css",
        "./site-loader/node_modules/ace-css/css/ace.min.css",
        "./site-loader/node_modules/basscss-grid/css/grid.css",
        "./site-loader/node_modules/bootstrap/dist/css/bootstrap.css",
        "./sites/#{site}/templates/**/*.css" ])
      .pipe(concat "assets/css/vendor.css")
      .pipe gulp.dest "newfiles/"
    gulp.src(["./sites/#{site}/payload-/css/*.css","./site-loader/app/css/*.css" ])
      .pipe(concat "assets/css/app.css")
      .pipe gulp.dest "newfiles/"
    return
  exports[site] = do (site)-> return ()->
    exports[site + "Js"]()
    exports[site + "Html"]()
    exports[site + "Css"]()
    return

exports.default = exports.stjohnsjim
console.log exports

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
