
  Model = require '../models/base/model.coffee'

  'use strict'

  module.exports = class Story extends Model
    href: (against = false)=>
      ref = "#{@get 'category'}/#{@get 'slug'}.html"
      ref = ref.replace /\ /g,'_'
      if !against || against == window.siteHandle
        return ref
      return  "#{against}/#{ref}" if against.match '/'
      
    initialize: () ->
      super()
