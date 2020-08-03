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
bpr= require './node_modules/browser-pack-register/index.js'
coffee = require 'gulp-coffee'
wrapCommonJS = require "gulp-wrap-commonjs"
requireJSSource =  fs.readFileSync "./node_modules/commonjs-require-definition/require.js"

through = require('through2')
tildify = require('tildify')
stringifyObject = require('stringify-object')
objectAssign = require('object-assign')
plur = require('plur')
chalk = require('chalk')
prop = chalk.blue

DBModel = Backbone.Model.extend
  default:
    draft: true
DBColl = Backbone.Collection.extend
  model: DBModel
allDB = new DBColl()

dumpDB= ()->
  console.log allDB.toJSON()
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
  if process.argv.indexOf('--verbose') != -1
    opts.verbose = true
    opts.minimal = false
  count = 0
  through.obj ((file, enc, cb) ->
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
#

#console.log S
for site in ['stjohnsjim',"celarien","bamboosnow","lowroller","nia-happenings"]
  exports[site + 'Html'] = do (site)-> return (cb)->
    console.log "in HTML"
    siteTemplate = fs.readFileSync "./sites/#{site}/templates/#{site}template.coffee"
    HalvallaCard = fs.readFileSync "./sites/#{site}/templates/card.coffee"
    console.log "Generating #{site}"
    a=pfs(
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
        .pipe gulp.dest("sites/#{site}/public/")
    )
    b=()->
      console.log "starting Mystories"
      myStories = allDB.filter site: site
      allStories = allDB
      
      return pfs(gulp.src('./mystories.json', allowEmpty:true)
        .pipe gulpInsert.append "myStories=#{JSON.stringify myStories}"
        .pipe rename 'mystories.json'
        .pipe gulp.dest "sites/#{site}/public/"
        )
    c=()->
      console.log "starting allstories"
      allStories = allDB
      
      return pfs(gulp.src('./allstories.json', allowEmpty:true)
        .pipe gulpInsert.append "allStories=#{JSON.stringify allStories.toJSON()}"
        .pipe rename 'allstories.json'
        .pipe gulp.dest "sites/#{site}/public/"
        )
    a.then( b).then(c).then ()->
     console.log "DONE HTML and stories"
     cb() if cb

  exports[site + 'AppJs'] = do (site)-> return (cb)->
    console.log "in JS"
    bb= browserify "./app/initialize.coffee",
      transform: ['coffeeify','deamdify']
      extensions: ['.coffee']
      fullPaths: true
      paths:['./node_modules','./app',"./sites/#{site}","./sites/#{site}/payload-","./sites/#{site}/node_modules"]
      basedir: "/Users/jahbini/mar1on/site-master"
      prelude: "JAH bcp here"
      read:false
    bb.require './app/initialize.coffee'
    xx= bb.pipeline.get 'pack'
    yy= xx.pop()
    #xx.push bpr raw:true, prelude: requireJSSource.toString()
    xx.push bpr raw:true
    b1= toVinyl bb
    b2= b1.bundle("assets/js/app.js")
      #.pipe wrapCommonJS relativePath:"./node_modules/"
      #.pipe gulpInsert.append "\nrequire.alias('../../assets/js/app.js','initialize');"
      .pipe examineBundle verbose:true,minimal:false
      .pipe gulp.dest("sites/#{site}/public/")
      
  exports[site + 'VendorJs'] = do (site)-> return (cb)->
    gulp.src([
        "./node_modules/jquery/dist/jquery.js"
        "./node_modules/asap/asap.js"
      ])
     .pipe gulpAddSource.append './node_modules/bootstrap/dist/js/bootstrap.js'
     .pipe gulpAddSource.append './node_modules/backbone/backbone.js'
     .pipe gulpAddSource.append './node_modules/base64-js/index.js'
     .pipe gulpAddSource.append './node_modules/buffer/index.js'
     .pipe gulpAddSource.append './node_modules/chroma-js/chroma.js'
     .pipe gulpAddSource.append './node_modules/font-face-observer/src/dom.js'
     .pipe gulpAddSource.append './node_modules/font-face-observer/src/observer.js'
     .pipe gulpAddSource.append './node_modules/font-face-observer/src/ruler.js'
     .pipe gulpAddSource.append './node_modules/halvalla/lib/halvalla-mithril.js'
     .pipe gulpAddSource.append './node_modules/halvalla/lib/html-tags.js'
     .pipe gulpAddSource.append './node_modules/halvalla/lib/name-mine.js'
     .pipe gulpAddSource.append './node_modules/halvalla/lib/halvalla.js'
     .pipe gulpAddSource.append './node_modules/halvalla/lib/teacup.js'
     .pipe gulpAddSource.append './node_modules/ieee754/index.js'
     .pipe gulpAddSource.append './node_modules/isarray/index.js'
     .pipe gulpAddSource.append './node_modules/mithril/mithril.js'
     .pipe gulpAddSource.append './node_modules/mss-js/mss.js'
     .pipe gulpAddSource.append './node_modules/palx/dist/hue-name.js'
     .pipe gulpAddSource.append './node_modules/palx/dist/index.js'
     .pipe gulpAddSource.append './node_modules/process/browser.js'
     .pipe gulpAddSource.append './node_modules/promise/index.js'
     .pipe gulpAddSource.append './node_modules/promise/lib/node-extensions.js'
     .pipe gulpAddSource.append './node_modules/promise/lib/es6-extensions.js'
     .pipe gulpAddSource.append './node_modules/promise/lib/done.js'
     .pipe gulpAddSource.append './node_modules/promise/lib/core.js'
     .pipe gulpAddSource.append './node_modules/underscore/underscore.js'
     .pipe wrapCommonJS relativePath:"./node_modules/"
     .pipe examineBundle verbose:true,minimal:false
     .pipe(concat "assets/js/vendor.js")
     .pipe gulpInsert.prepend requireJSSource + ";"
     .pipe gulpInsert.append """
require.alias('jquery/dist/jquery.js','jquery');
require("jquery");
     """
     .pipe gulp.dest "sites/#{site}/public/"

  exports[site + 'Assets'] = do (site) -> return (cb)->
    console.log site, "performing Assets"
    sources=["./sites/#{site}/payload-/assets/**/*", "./sites/#{site}/templates/**/*.jpg", "./sites/#{site}/templates/**/*.png" ]
    a=pfs(
      gulp.src sources
        .pipe examineBundle title: "ASSET bundle", minimal:false
        .pipe gulp.dest "sites/#{site}/public/"
    )
    a.then ()->
     console.log "DONE Assets"
     cb() if cb

    if site == "nia-happenings"
      sources = "./sites/nia-web/dist/assets/**/*"
      a=pfs(
        gulp.src sources
          .pipe examineBundle title: "nia-web ASSET bundle", minimal:false
          .pipe gulp.dest "sites/#{site}/public/assets"
      )
      a.then ()->
       console.log "DONE nia-web Assets"
       cb() if cb


  exports[site + 'Css'] = do (site) -> return (cb)->
    console.log site, "performing CSS"
    a=gulp.src([
        "./node_modules/blaze/scss/dist/blaze.min.css",
        "./node_modules/ace-css/css/ace.min.css",
        "./node_modules/basscss-grid/css/grid.css",
        "./node_modules/bootstrap/dist/css/bootstrap.css",
        "./sites/#{site}/templates/**/*.css" ])
      .pipe(concat "assets/css/vendor.css")
      .pipe gulp.dest "sites/#{site}/public/"

    b=()->
      console.log "starting B"
      return pfs(gulp.src([ "./app/css/*.css" , "./sites/#{site}/payload-/*.css" ])
        .pipe concat "assets/css/app.css"
        .pipe gulp.dest "sites/#{site}/public/"
        )
    pfs(a).then( b).then ()->
      console.log("DONECSS")
      cb() if cb
    
  exports[site] = do (site)-> return (cb)=>
    console.log "Activating Series",site
    exports[site + "VendorJs"]()
    exports[site + "AppJs"]()
    exports[site + "Html"]()
    exports[site + "Css"]()
    exports[site + "Assets"]()

exports.default = exports['nia-happenings']
console.log exports

return
