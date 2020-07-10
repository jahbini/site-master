#
# Story model and Stories collection
#
Backbone = require 'backbone'
_ = require 'underscore'
moment = require 'moment'
Cson = require 'cson'

class Story extends Backbone.Model
  canPublish:()=>
    @attributes.accepted && moment(@attributes.embargo) < moment() && !@attributes.drafts
      
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
  fieldsOf:(indent)=>
    spaces = '  '.repeat indent
    raw = Cson.createCSONString  @.attributes, indent:'  ' 
    (raw.split '\n').join "\n  "
    
class Stories extends Backbone.Collection
  model: Story
  toWriteable:()=>
    return 
      results:@.map (site)->site.toWriteable()
      count: @.size()
  addStoriesFromJSON: (json)=>
    for story in json.results
      fields=story.fields
      fields.id = story.id
      fields.snippets ='{}' unless fields.snippets
      fields.author = '' unless fields.author
      fields.name = story.name
      delete fields.content
      @add fields
    @
  
makeStory = (site,category,slug)->
  return new Story
    title: slug
    slug: slug
    category: category
    site: site.get 'id'
    accepted: false
    index: false
    sourcePath: ""
    headlines: []
    tags: []
    snippets: "{\"first name\":\"first name\"}"
    memberOf: []
    created: moment()
    lastEdited: moment()
    published: moment()
    embargo: moment()
    captureDate: moment()
    TimeStamp: moment().valueOf() 
    debug: ""
    author: site.get 'author'
    id: "#{site.get 'name'}/#{category}/#{slug}"
    name: slug
module.exports = { Story, Stories, makeStory }
