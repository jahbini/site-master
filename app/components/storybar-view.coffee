# put outbound links into story

T = Pylon.Halvalla
B = require 'backbone'

siteBase = topDomain.split '.'
z=siteBase.shift()

module.exports = T.bless class Storybar 
  displayName: 'Storybar'
  
  view: (vnode)=>
    collection = vnode.attrs.collection
    filter = vnode.attrs.filter || ()->true
    intermediate = collection.filter filter,@
    story = null
    until story
      story = _.sample intermediate
      return null unless story
      badClass = 'category' == story.get 'className'
      badHeadline = (story.get 'headlines') < 1
      story = null if badClass || badHeadline
    try
      storyFrom = story.get('site')
    catch error
      console.log "Ailing Story",story
      return null
    siteBase = topDomain.split '.'
    siteBase.shift()
    siteBase.unshift storyFrom
  
    return T.div ".c-card",->
      T.div ".c-card__item.bg-silver",->
        T.a ".c-link.c-link--brand",href: (story.href 'http://'+siteBase.join '.'),-> 
          T.div ->
            T.h4 ->
              T.raw "From Around the Web: "
              T.span ".u-text--quiet.u-text--highlight","#{story.get 'title'}: #{(_.sample story.get 'headlines')||''}"
