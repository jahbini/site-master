# 
T = require 'halvalla'
#include card.coffee
module.exports = class celarientemplate
  #pass the db entry into the class so that the classes have access to it
  constructor: (@db,@allDB)->
  #
  # section storyHeadMatter
  #
  storyHeadMatter: =>
    return
  # 
  # section html
  # 
  html: =>
    T.doctype 'html'
    T.html =>
      T.head =>
        T.base href: "/"
        T.meta name: "author", content: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
        T.meta "http-equiv": "Content-Type", content: "text/html", charset: "UTF-8"
        T.meta name: "viewport", content: "width=device-width, initial-scale=1"
        T.title => T.raw "Practical Metaphysics and Harmonious Mana."
        T.meta name: "description", content: "some good thoughts. Maybe."
        T.meta name: "keywords", content: "romance, wisdom, tarot"
        T.meta property: "fb:admins", content: "1981510532097452"
        T.script """
// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
//console.log('statusChangeCallback');
//console.log(response);
// The response object is returned with a status field that lets the
// app know the current login status of the person.
// Full docs on the response object can be found in the documentation
// for FB.getLoginStatus().
if (response.status === 'connected') {
  // Logged into your app and Facebook.
  testAPI();
} else {
  // The person is not logged into your app or we are unable to tell.
  document.getElementById('fb-status').innerHTML = 'Please log ' +
    'into this app.';
}
}

// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
function checkLoginState() {
FB.getLoginStatus(function(response) {
  statusChangeCallback(response);
});
}

window.fbAsyncInit = function() {
FB.init({
appId      : '1981510532097452',
cookie     : true,  // enable cookies to allow the server to access 
                    // the session
xfbml      : true,  // parse social plugins on this page
version    : 'v2.8' // use graph api version 2.8
});

// Now that we've initialized the JavaScript SDK, we call 
// FB.getLoginStatus().  This function gets the state of the
// person visiting this page and can return one of three states to
// the callback you provide.  They can be:
//
// 1. Logged into your app ('connected')
// 2. Logged into Facebook, but not your app ('not_authorized')
// 3. Not logged into Facebook and can't tell if they are logged into
//    your app or not.
//
// These three cases are handled in the callback function.

FB.getLoginStatus(function(response) {
statusChangeCallback(response);
});

};

// Load the SDK asynchronously
(function(d, s, id) {
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) return;
js = d.createElement(s); js.id = id;
js.src = \"//connect.facebook.net/en_US/sdk.js\";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// Here we run a very simple test of the Graph API after login is
// successful.  See statusChangeCallback() for when this call is made.
function testAPI() {
//console.log('Welcome!  Fetching your information.... ');
FB.api('/me', 'get', {'fields':'first_name,gender'}, function(response) {
  //console.log('Successful login for: ', response);
  $('.FBname').text(response.first_name);
  document.getElementById('fb-status').innerHTML =
    'Thanks for logging in, ' + response.first_name + '!';
});
}
"""
        T.script "document.styling = {\"palx\":\"#03c\",\"black\":\"#000\",\"white\":\"#fff\"}"
        T.link rel: "apple-touch-icon", sizes: "57x57", href: "/assets/icons/apple-icon-57x57.png"
        T.link rel: "apple-touch-icon", sizes: "60x60", href: "/assets/icons/apple-icon-60x60.png"
        T.link rel: "apple-touch-icon", sizes: "72x72", href: "/assets/icons/apple-icon-72x72.png"
        T.link rel: "apple-touch-icon", sizes: "76x76", href: "/assets/icons/apple-icon-76x76.png"
        T.link rel: "apple-touch-icon", sizes: "114x114", href: "/assets/icons/apple-icon-114x114.png"
        T.link rel: "apple-touch-icon", sizes: "120x120", href: "/assets/icons/apple-icon-120x120.png"
        T.link rel: "apple-touch-icon", sizes: "144x144", href: "/assets/icons/apple-icon-144x144.png"
        T.link rel: "apple-touch-icon", sizes: "152x152", href: "/assets/icons/apple-icon-152x152.png"
        T.link rel: "apple-touch-icon", sizes: "180x180", href: "/assets/icons/apple-icon-180x180.png"
        T.link rel: "icon", type: "image/png", sizes: "192x192", href: "/assets/icons/android-icon-192x192.png"
        T.link rel: "icon", type: "image/png", sizes: "32x32", href: "/assets/icons/favicon-32x32.png"
        T.link rel: "icon", type: "image/png", sizes: "96x96", href: "/assets/icons/favicon-96x96.png"
        T.link rel: "icon", type: "image/png", sizes: "16x16", href: "/assets/icons/favicon-16x16.png"
        T.link rel: "manifest", href: "/assets/manifest.json"
        T.meta name: "msapplication-TileColor", content: "#ffffff"
        T.meta name: "msapplication-TileImage", content: "/assets/icons/ms-icon-144x144.png"
        T.meta name: "theme-color", content: "#ffffff"
        #T.link rel: "stylesheet", href: "assets/css/vendor.css", "-content--encoding": "gzip"
        #T.link rel: "stylesheet", href: "assets/css/app.css", "-content--encoding": "gzip"
        T.link rel: "stylesheet", href: "app.css", "-content--encoding": "gzip"
        T.link rel: "shortcut icon", href: "assets/icons/favicon.ico", type: "image/x-icon"
        T.link rel: "icon", href: "assets/icons/favicon.ico", type: "image/x-icon"
        T.script src: "allstories.json"
        T.script src: "mystories.json"
        T.script src: "assets/js/vendor.js", "-content--type": "text/javascript", "-content--encoding": "gzip"
        T.script src: "assets/js/app.js", "-content--type": "text/javascript", "-content--encoding": "gzip"
        T.script "siteHandle = 'celarien'; topDomain = 'celarien.com'; require('initialize');"
        @storyHeadMatter()
      T.body =>
        @celarien_body()
  # 
  # section celarien_body
  # 
  celarien_body: =>
    T.div "#celarien-body.c-text.o-grid.o-grid--full", =>
      T.div ".style.c-hero", style: "{ border-bottom: 1px solid #333; }"
      T.div ".c-hero.o-grid__cell.u-higher", =>
        @header()
      T.div ".o-grid__cell", style: "min-height:100vh", =>
        T.div ".o-grid", =>
          T.div "#storybar.o-grid__cell.order-2",=>
            @storyBar()
          @sidebar()
          @sidecar()
      @footer()
      @cover()
  # 
  # section storyBar
  #
  storyBar: =>
    headlines = @db.headlines
    headline = '---'
    if l=headlines?.length
      r = Math.floor (Math.random() * l)
      headline = headlines[r ]
    HalvallaCard "#main.bg-silver",{
      shadow:"highest"
      divider:true
      footerText: "that's all--"
      headerText: @db?.title
      subHeaderText: headline
      content: @bloviation
      }
  #
  # section cover
  # 
  # 
  # section footer
  # 
  footer: =>
    T.div "#footer.panel", bg: "white", =>
      T.h2 => T.raw "All contents copyright 2015, James A. Hinds"
      T.p => T.raw "The ideas are yours to keep and share, the wording is mine."
  # 
  # section sidecar
  # 
  sidecar: =>
    T.div "#sidecar.o-grid__cell.o-grid__cell--width-fixed.order-last.bg-darken-2", style: "min-width:240", =>
      T.div ".fb-login-button", width: "200", "data-width": "200", "data-max-rows": "1", "data-size": "medium", "data-button-type": "login_with", "data-show-faces": "true", "data-auto-logout-link": "true", "data-use-continue-as": "true"
      @fb_status()
  # 
  # section fb_status
  # 
  fb_status: =>
    T.div "#fb-status"
  # 
  # section sidebar
  # 
  sidebar: =>
    T.aside "#sidebar.o-grid__cell.o-grid__cell--width-20.p2.bg-darken-2", style: "min-width:240"
  # 
  # section storybar
  # 
  # 
  # section bloviation
  # 
  # 
  # section header
  # 
  header: =>
    T.header "#header.o-grid.o-grid--bottom", style: "height:250px", =>
      T.div ".c-avatar.u-super", =>
        T.img ".c-avatar__img", style: "-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;ms-filter:FlipH", src: "http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
      T.div ".o-grid__cell.o-grid__cell--width-30", =>
        T.h3 =>
          T.a ".fa.fa-home", href: "/", => T.raw "Home"
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
