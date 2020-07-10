T = Pylon.Halvalla
B = require 'backbone'
{  Panel, PanelHeader, Link } = Pylon.Rebass
###  
Panel = T.bless Panel
Link = T.bless Link
PanelHeader = T.bless PanelHeader

module.exports.holyGrail = T.bless class HolyGrail extends React.Component

    
  render: ()=>
    options = _.pluck @props, 'user','navLinks','story','page'
    T.div '.o-grid.o-grid--full', ()->
      @props.header '.o-grid__cell',options
      T.div '.o-grid__cell',->
        T.div '.o-grid',->
          @props.left
        T.div '.o-grid__cell',->
          @props.middle
        T.div '.o-grid__cell',->
          @props.right
      @props.footer '.o-grid__cell',options
        
  

module.exports.Panel =   class Panel extends B.Model
  displayName: 'Panel'
  constructor: (@props)->
    @
  style: ()=>
      overflow: 'hidden'
      borderRadius: px @props.theme.radius
      borderWidth: px 1
      borderStyle: 'solid'
  view: ()=>
      T.div style: @style @props.style,children: @props.children
      
module.exports.PanelHeader =   class PanelHeader extends B.Model
  displayName: 'PanelHeader'
  constructor: (@vnode)->
    @props= f:2, p:2
    console.log "PanelHeader constructor",@vnode
    @
    
  style: (props)=>
    fontWeight: bold(props),
    borderBottomWidth: px(1),
    borderBottomStyle: 'solid',
  view: ()->
      T.crel 'Header', style: @style @vode.style
      
###