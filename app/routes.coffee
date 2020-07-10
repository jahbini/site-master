'use strict'

routes = (match) ->
  match '/', 'home#show'
  match 'showit', 'sidebar#showit'

module.exports = routes
