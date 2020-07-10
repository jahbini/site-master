BaseController = require 'controllers/base/controller'

'use strict'


module.exports = class PageController extends BaseController

  beforeAction: (actionParams, controllerOptions) ->
    Chaplin.mediator.controllerAction = controllerOptions.action
    Chaplin.mediator.actionParams = actionParams
