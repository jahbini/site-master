#
#routes = require 'routes'
window.$= jQuery
window._ = require 'lodash'
Backbone = require 'backbone'

PylonTemplate = Backbone.Model.extend
#  state: (require './models/state.coffee').state
   Mithril: require 'mithril'
   #Mui: require 'mui'
   Mss: require 'mss-js'
   Halvalla: require 'halvalla/lib/halvalla-mithril'
   Palx: require 'palx'
   Utils: require './lib/utils'
   Underscore: require 'underscore'
   Backbone: Backbone
window.Pylon = Pylon = new PylonTemplate
window._$_ = Pylon

Pylon.Button = require './components/button' # Pylon is assumed to be a global for this guy

Pylon.on 'all', (event,rest...)->
  mim = event.match /((.*):.*):/
  return null if !mim || mim[2] != 'systemEvent'
  applogger "event #{event}"
  Pylon.trigger mim[1],event,rest
  Pylon.trigger mim[2],event,rest
  return null


FontFaceObserver = require 'font-face-observer'
T = Pylon.Halvalla
Mithril = Pylon.Mithril
Sidebar = require './components/sidebar-view'
Storybar = require './components/storybar-view'
Fibonacci = require './components/fibonacci'
routes = require './routes'
Palx = Pylon.Palx

newColors = Palx document.styling.palx
newColors.black= document.styling.black
newColors.white= document.styling.white

# gather the global JSONs into Backbone collections 
{myStories,allStories} = require './models/stories'

# suppress react styling
###
styled= require   'styled-components'
{ injectGlobal, keyframes } = styled
styled = styled.default

injectGlobal""" 
  body {
    * {box-sizing: border-box; }
    body { margin: 0; }
    font-family: sans-serif;
  }
"""
###

# Initialize the application on DOM ready event.
$ ->
  
  mine =
    collection: myStories
    filter: (story)-> 'draft' != story.get 'category'
    
  theirs =
    collection: allStories
    filter: (story)-> 'draft' != story.get 'category'
    
  try
    realNode = document.getElementById('sidebar')
    #sidebarContents = T.Provider  theme: colors: newColors, Sidebar mine
    sidebarContents = Sidebar mine
    Mithril.render realNode, sidebarContents
  catch badDog
    console.log badDog
  
  divs= $('.siteInvitation')
  divs.each (key,div)->
    Mithril.render div, Storybar theirs
  bloviation = document.getElementById 'fibonacci'
  Mithril.render bloviation, Fibonacci 1,2,3,4,5,6 if bloviation
  
