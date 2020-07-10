PageController =  require 'controllers/page'
log = require 'loglevel'

'use strict'

module.exports =  class HomeController extends PageController
    showit: () ->
      return false

    show: () ->
      log.info 'HomeController:show'
