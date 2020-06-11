'use strict'
path = require('path')
gutil = require('gulp-util')
through = require('through2')
tildify = require('tildify')
stringifyObject = require('stringify-object')
chalk = require('chalk')
objectAssign = require('object-assign')
plur = require('plur')
prop = chalk.blue

module.exports = (opts) ->
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
    gutil.log opts.title + ' ' + output
    cb null, file
    return
  ), (cb) ->
    gutil.log opts.title + ' ' + chalk.green(count + ' ' + plur('item', count))
    cb()
    return
