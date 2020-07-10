#
# site model and sites collection
#
Backbone= require 'backbone'
_ = require 'underscore'

class Site extends Backbone.Model
  toWriteable:()=>
    raw = @.toJSON()
    delete raw.id
    delete raw.name
    delete raw.fields
    structure = 
      id: @id
      name: @.get 'name'
      fields: raw
    structure

  
class Sites extends Backbone.Collection
  model: Site
  toWriteable:()=>
    return 
      results:@.map (site)->site.toWriteable()
      count: @.size()

buildSites = (json)->
  sites = new Sites
  for site in json.results
    fields=site.fields
    fields.id = site.id
    fields.name = site.name
    sites.add fields
    #console.log "site fields", fields
  sites
module.exports = {buildSites,Site,Sites}