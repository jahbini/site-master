#
# Brunch-config.coffee meta file
#
siteDir = process.env.PWD
nodeModules = "#{siteDir}/node_modules/"
siteTemplates = "#{siteDir}/templates/"
sitePublic = "#{siteDir}/public/"
sitePayload = "#{siteDir}/payload-/"
myDir = "#{siteDir}/node_modules/site-master/"
console.log "PAYLOAD",sitePayload

Backbone = require 'backbone'
_=require 'lodash'
path = require 'path'
fs = require 'fs'
autoprefixer = require('gulp-autoprefixer')
beautify = require('gulp-beautify')
browserSync = require('browser-sync').create()
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
sequencer = require 'gulp-sequence'
os = require('os')
pkg = require('./package.json')
# browserify stuff
browserify = require 'browserify'
#vinylify = require "vinylify"
source=require 'vinyl-source-stream'
buffer=require 'vinyl-buffer'
deamdify = require 'deamdify'
coffeeify = require 'coffeeify'
bpr= require nodeModules+'/browser-pack-register/index.js'
coffee = require 'gulp-coffee'
wrapCommonJS = require "gulp-wrap-commonjs"
requireJSSource =  fs.readFileSync nodeModules+"/commonjs-require-definition/require.js"
gulpWatch = require 'gulp-watch'

through = require('through2')
tildify = require('tildify')
stringifyObject = require('stringify-object')
objectAssign = require('object-assign')
plur = require('plur')
chalk = require('chalk')
siteDef = require siteDir+'/site.coffee'
prop = chalk.blue

for key of siteDef
  site = key

  console.log "SITE!!:",site


DBModel = Backbone.Model.extend
  default:
    draft: true
DBColl = Backbone.Collection.extend
  model: DBModel
allDB = new DBColl()

dumpDB= ()->
  #console.log allDB.toJSON()

pfs = (stream) ->
    new Promise((resolve, reject) ->
      stream.on 'finish', resolve
      stream.on 'end', resolve
      # unsure if should use finish or end
      stream.on 'error', reject
      return
      )
examineBundle = (opts) ->
  opts = objectAssign({
    title: 'gulp-browserify-debug:'
    minimal: true
  }, opts)
  opts.verbose = true
  opts.minimal = false
  if process.argv.indexOf('--verbose') != -1
    opts.verbose = true
    opts.minimal = false
  count = 0
  through.obj ((file, enc, cb) ->
    console.log "FILE"
    for keys,vals of file
      console.log key,vals
    full = '\n' + (if file.cwd then 'cwd:   ' + prop(tildify(file.cwd)) else '') + (if file.base then '\nbase:  ' + prop(tildify(file.base)) else '') + (if file.path then '\npath:  ' + prop(tildify(file.path)) else '') + (if file.stat and opts.verbose then '\nstat:  ' + prop(stringifyObject(file.stat, indent: '       ').replace(/[{}]/g, '').trim()) else '') + '\n'
    output = if opts.minimal then prop(path.relative(process.cwd(), file.path)) else full
    count++
    #console.log opts.title + ' ' + output
    #console.log file.contents.toString()
    cb null, file
    return
  ), (cb) ->
    console.log opts.title + ' ' + chalk.green(count + ' ' + plur('item', count))
    dumpDB()
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
    try
      raw = file.contents.toString()
      file.extname ='.html'
      data = eval raw
      data = JSON.parse data
      db=data.db
      for key,val of db
        allDB.push val unless key.match /^\d+$/
      html= data.html || ""
      #allDB.push db
    catch err
      nc = err.toString()
      console.log  nc
      html= ""
      data = nc |  "-------\n" | file.contents.toString()
    file.contents = Buffer(html)
    cb null, file
    return
  ), (cb) ->
    console.log opts.title + ' ' + chalk.green(count + ' ' + plur('item', count))
    cb()
    return


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
#

exports.Html = (cb)->
    console.log "in HTML"
    siteTemplate = fs.readFileSync "#{siteTemplates}/sitetemplate.coffee"
    HalvallaCard = fs.readFileSync "#{siteTemplates}/card.coffee"
    console.log "Generating site"
    a=pfs(
      gulp.src("#{siteTemplates}/**/*.coffee")
        #.pipe gulpWatch  "#{siteTemplates}/**/*.coffee"
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
        .pipe gulp.dest sitePublic
    )
    b=()->
      console.log "starting Mystories"
      myStories = allDB.filter site: site
      allStories = allDB
      return new Promise  (r,f)-> 
        fs.writeFile sitePublic+"/mystories.json", "myStories=#{JSON.stringify myStories}",r()
    c=()->
      console.log "starting allstories"
      allStories = allDB
      return new Promise  (r,f)-> 
        fs.writeFile sitePublic+"/allstories.json",
          "allStories=#{JSON.stringify allStories}"
          r()
      
    a.then( b).then(c).then ()->
      browserSync.stream()
      console.log "DONE HTML and stories"
      cb() if cb

exports['AppJs'] = (cb)->
    console.log "in JS again"
    bb= browserify "app/initialize.coffee",
      transform: [coffeeify,deamdify]
      extensions: ['.coffee']
      fullPaths: true
      paths:[nodeModules,"#{myDir}/app",sitePayload]
      basedir: "."
      prelude: "JAH bcp here"
      read:false
    bb.require "initialize.coffee"
    xx= bb.pipeline.get 'pack'
    yy= xx.pop()
    xx.push bpr raw:true, prelude: requireJSSource.toString()
    #xx.push bpr raw:true
    b1= toVinyl bb
    b2= b1.bundle "waawaa"
      #.pipe wrapCommonJS relativePath:"./"
      .pipe(concat "assets/js/app.js")
      #.pipe gulpInsert.prepend requireJSSource + ";"
      .pipe gulp.dest sitePublic
      .pipe browserSync.stream()
      
exports['VendorJs'] =  (cb)->
    console.log "VendorJs",process.env.PWD,nodeModules
    gulp.src([
        "node_modules/jquery/dist/jquery.js"
        "#{nodeModules}/asap/asap.js"
      ])
     .pipe gulpAddSource.append "#{nodeModules}/bootstrap/dist/js/bootstrap.js"
     .pipe gulpAddSource.append "#{nodeModules}/backbone/backbone.js"
     .pipe gulpAddSource.append "#{nodeModules}/base64-js/index.js"
     .pipe gulpAddSource.append "#{nodeModules}/buffer/index.js"
     .pipe gulpAddSource.append "#{nodeModules}/chroma-js/chroma.js"
     .pipe gulpAddSource.append "#{nodeModules}/font-face-observer/src/dom.js"
     .pipe gulpAddSource.append "#{nodeModules}/font-face-observer/src/observer.js"
     .pipe gulpAddSource.append "#{nodeModules}/font-face-observer/src/ruler.js"
     .pipe gulpAddSource.append "#{nodeModules}/halvalla/lib/halvalla-mithril.js"
     .pipe gulpAddSource.append "#{nodeModules}/halvalla/lib/html-tags.js"
     .pipe gulpAddSource.append "#{nodeModules}/halvalla/lib/name-mine.js"
     .pipe gulpAddSource.append "#{nodeModules}/halvalla/lib/halvalla.js"
     .pipe gulpAddSource.append "#{nodeModules}/halvalla/lib/teacup.js"
     .pipe gulpAddSource.append "#{nodeModules}/ieee754/index.js"
     .pipe gulpAddSource.append "#{nodeModules}/isarray/index.js"
     .pipe gulpAddSource.append "#{nodeModules}/mithril/mithril.js"
     .pipe gulpAddSource.append "#{nodeModules}/mss-js/mss.js"
     .pipe gulpAddSource.append "#{nodeModules}/palx/dist/hue-name.js"
     .pipe gulpAddSource.append "#{nodeModules}/palx/dist/index.js"
     .pipe gulpAddSource.append "#{nodeModules}/process/browser.js"
     .pipe gulpAddSource.append "#{nodeModules}/promise/index.js"
     .pipe gulpAddSource.append "#{nodeModules}/promise/lib/node-extensions.js"
     .pipe gulpAddSource.append "#{nodeModules}/promise/lib/es6-extensions.js"
     .pipe gulpAddSource.append "#{nodeModules}/promise/lib/done.js"
     .pipe gulpAddSource.append "#{nodeModules}/promise/lib/core.js"
     .pipe gulpAddSource.append "#{nodeModules}/underscore/underscore.js"
     .pipe wrapCommonJS relativePath:"./"
     .pipe(concat "assets/js/vendor.js")
     .pipe gulpInsert.prepend requireJSSource + ";"
     .pipe gulpInsert.append """
require.alias('node_modules/jquery/dist/jquery.js','jquery');
require("jquery");
     """
     .pipe gulp.dest sitePublic
     .pipe browserSync.stream()

exports['Assets'] = (cb)->
    console.log site, "performing Assets"
    sources=["#{sitePayload}/assets/**/*", "#{siteTemplates}/**/*.jpg", "#{siteTemplates}/**/*.png" ]
    a=pfs(
      gulp.src sources
        .pipe examineBundle title: "ASSET bundle", minimal:true
        .pipe gulp.dest sitePublic
    )
    a.then ()->
     console.log "DONE Assets"
     cb() if cb

    if site == "nia-web"
      sources = "./site/dist/assets/**/*"
      a=pfs(
        gulp.src sources
          .pipe examineBundle title: "nia-web ASSET bundle", minimal:true
          .pipe gulp.dest "#{sitePublic}/assets"
      )
      a.then ()->
       console.log "DONE nia-web Assets"
       cb() if cb


exports['Css'] = do (site) -> return (cb)->
    console.log site, "performing CSS into #{sitePublic}"
    console.log "#{nodeModules}/ace-css/css/ace.min.css"
    a=gulp.src([
        "#{nodeModules}/blaze/scss/dist/blaze.min.css",
        "#{nodeModules}/ace-css/css/ace.min.css",
        "#{nodeModules}/basscss-grid/css/grid.css",
        "#{nodeModules}/bootstrap/dist/css/bootstrap.css",
        "#{siteTemplates}/**/*.css" ])
      .pipe(concat "assets/css/vendor.css")
      .pipe gulp.dest sitePublic

    b=()->
      console.log "starting B"
      return pfs(gulp.src([ "#{myDir}/app/css/*.css" , "#{sitePayload}/*.css" ])
        .pipe concat "assets/css/app.css"
        .pipe gulp.dest sitePublic
        )
    pfs(a).then( b).then ()->
      console.log "#{sitePublic}/assets/css/app.css"
      console.log("DONECSS")
      cb() if cb
    
exports.watch = (cb)->
  gulp.watch "#{siteTemplates}/**/*.css",exports.Css
  gulp.watch ["#{sitePayload}/assets/**/*", "#{siteTemplates}/**/*.jpg", "#{siteTemplates}/**/*.png" ] , exports.Assets
  gulp.watch  "#{siteTemplates}/**/*.coffee",exports.Html().then (done)->
    browserSync.reload()
    console.log done,"DONE"
  cb()

exports.dist = gulp.series exports.Assets,exports.VendorJs, exports.AppJs, exports.Html, exports.Css

# Init live server browser sync
initBrowserSync = (done)->
  browserSync.init
    server:
      baseDir: sitePublic
    logLevel: "debug"
    port: 3000
    localOnly: false
    notify: true
  done();

exports.default = exports.start =  gulp.series(exports.dist, gulp.parallel(initBrowserSync, exports.watch))
console.log exports

return
