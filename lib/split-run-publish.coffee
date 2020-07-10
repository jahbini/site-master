#
# global srp
#
#  CoffeeScript.run fs.readFileSync('Cakefile').toString(), filename: 'Cakefile'

_ = require 'underscore'
fs = require 'fs'
CoffeeScript = require 'coffee-script'

blend= (directories,l)->
  newl = ''
  sl = l
  for s in l
    fragment =s.split /^( *#include .*)$[\n\r]?/m
    for subs in fragment
      if subs.match  /^( *#include .*)$/
        #console.log "match substring", subs
        leading = subs.match /^ */
        fileName = subs.replace /^ *#include /,''
        contents = null
        for directory in directories
          if ! contents
            try
              contents = fs.readFileSync directory+fileName,'utf8'
            catch
              contents = null
            
        if !contents 
          console.log "Fatal - no file #{directory+fileName} for #include"
          process.exit 1
        contents = contents.replace /^/gm,leading #prepend leading spaces
        newl += contents.replace /[\s\uFEFF\xA0\n]+$/, '' # trim last line endings
        #console.log "contents=",[contents]
        newl += "\r\n"
      else
        newl += subs.replace /[\s\uFEFF\xA0\n]+$/, '' # trim last line endings
        newl += "\r\n"

#  console.log "done  ",newl 
#  console.log "    l=",l
#  console.log "origl=",sl
#
#
#blend [
# "wow"
# "goomba\r\n 98765432\r\r\n <-trimmed???->\r\r"
# "baba baba \r\n#include corny\r\n lalalax\r\n  #include blarney\r\nnonononoooo!"
# ]
  CoffeeScript.run newl
  return
  
srp.expand = (story)->
  console.log "expanding", story?.id || story? || "story null"
  return unless story?
  destPre = './public-'
  theSite = srp.sites.get story.get 'site'
  siteName = theSite.get 'name'
  category = story.get 'category'
  category = category.replace /\ /g,'_'
  slug = story.get 'slug'
  
  templateDir = "./sites/#{siteName}/templates/"
  siteTemplateFile ="#{templateDir}#{siteName}template.coffee"
  categoryDir = "#{templateDir}#{category}/"
  storySrcTmp = "#{categoryDir}#{slug}"
  storySourcePath = "./#{storySrcTmp}.coffee"
  storySrcDir = storySrcTmp + "/"
  htmlDest = "#{destPre}#{siteName}/#{category}/#{slug}.html"
  directories = [
    storySrcDir
    categoryDir
    templateDir
    "./includes/"
    ]
    
  #fs.writeFileSync storySourcePath, storySource
  
  blend directories,[
    """
#preamble
    """
    siteTemplate=fs.readFileSync siteTemplateFile,'utf-8'
    srp.source = fs.readFileSync storySourcePath,'utf-8'
    """
#postamble
if renderer?
  page = new renderer db[id],db
  rendered = T.render page.html
else
  console.log "story does not define a renderer"
  process.exit 1
srp.rendered = rendered
srp.db= db[id]
    """
    ]
