# #-------- class start
renderer = class index extends {{site}}template
  # 
  # section html
  # 
  # 
  # section celarien_body
  # 
  # 
  # section cover
  # 
  cover: =>
    T.div "#cover", style: "background-image:url(/assets/images/hooray-fade2.jpg);-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;ms-filter:FlipH"
  # 
  # section footer
  # 
  # 
  # section sidecar
  # 
  # 
  # section fb_status
  # 
  # 
  # section sidebar
  # 
  # 
  # section storybar
  # 
  storybar: =>
    T.div "#storybar.o-grid__cell.order-2.bg-lighten-2", =>
      T.h1 => T.raw "Headline here"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", =>
      T.p => T.raw "Your index page text here"
  # 
  # section header
  # 
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end


# ------- db start
db = {} unless db

db[id="{{site}}/-/index"] =
  title: "Celarien -- The tools of the spiritual bodyguard"
  slug: "index"
  category: "-"
  site: "{{site}}"
  accepted: true
  index: true
  headlines: [
    "write four headlines"
    "Wisdom starts here"
    "There are Diamonds at your feet if you only look"
    "Western Metaphysical NLP"
  ]
  tags: []
  snippets: "{}"
  memberOf: []
  created: "2016-03-11T12:40:04.000Z"
  lastEdited: "2016-03-11T14:20:28.000Z"
  published: "2016-03-11T12:40:04.000Z"
  embargo: "2016-03-11T12:40:04.000Z"
  captureDate: "2017-07-28T18:34:03.000Z"
  TimeStamp: "1501266843000"
  author: "Copyright 2010-2018 James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  debug: ""
  id: "{{site}}/-/index"
  name: "Celarien -- The tools of the spiritual bodyguard"
#