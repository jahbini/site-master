T = Pylon.Halvalla
B = require 'backbone'
#{  Panel, PanelHeader, Link } = Pylon.Rebass
  
#Panel = T.bless Panel
#Link = T.bless Link
#PanelHeader = T.bless PanelHeader


module.exports =  T.bless class Fibonacci extends B.Model
  displayName: 'Fibonacci'
  
  rollSquare =(a,b)->
    (a>>b)&1
  
  ratioToPixels = (xRaw,yRaw)->
    console.log "Ratio x,y=",xRaw,yRaw
    console.log "Ratio = ", (xRaw/yRaw+yRaw/xRaw) 
    return null if (xRaw/yRaw+yRaw/xRaw) > 2.4
    xRaw=Math.floor xRaw
    yRaw=Math.floor yRaw
    return 
      x: xRaw
      xpx: (xRaw)+'px'
      y: yRaw
      ypx: (yRaw)+'px'
      
  Lozenge = (n,x,y)->
    shrink = Math.pow 0.618033 , n
    return T.div "#last.bg-red.n-#{n}.left",width:x,height:y,style: {minWidth:x+"px", minHeight:y+"px"} unless px=ratioToPixels x,y
    {x,y,xpx,ypx} = px
    if x>y
      lx = Math.floor x-y
      T.div  ".h-lozenge.left",width:xpx, height:ypx, style: {width:xpx, height:ypx}, ->
        if rollSquare hexagramNumber,n
          Lozenge n+1, lx,y 
          T.div squareOptions[n].classNames,  width:ypx,height:ypx, style: {backgroundColor:squareOptions[n].color,width:ypx,height:ypx}, ->
            T.div style: {WebkitTransformOrigin:'top left', WebkitTransform:"scale(#{shrink})",width:'711px',height:'711px'}, ->
              T.div "#sq-#{n}",onclick:"swap(#{n})",->
                squareOptions[n].src
        else
          T.div squareOptions[n].classNames, width:ypx,height:ypx, style: {backgroundColor:squareOptions[n].color,width:ypx,height:ypx}, ->
            T.div style: {WebkitTransformOrigin:'top left', WebkitTransform:"scale(#{shrink})",width:'711px',height:'711px'}, ->
              T.div "#sq-#{n}",onclick:"swap(#{n})",->
                squareOptions[n].src
          Lozenge n+1, lx,y 
    else
      ly = Math.floor y-x
      T.div  ".v-lozenge.left",width:xpx, height:ypx, style: {width:xpx, height:ypx}, ->
        if rollSquare hexagramNumber,n
          T.div squareOptions[n].classNames, width:xpx,height:xpx, style: {backgroundColor:squareOptions[n].color,width:xpx,height:xpx}, ->
            T.div style: {WebkitTransformOrigin:'top left', WebkitTransform:"scale(#{shrink})",width:'711px',height:'711px'}, ->
              T.div "#sq-#{n}",onclick:"swap(#{n})",->
                squareOptions[n].src
          Lozenge n+1, x,ly 
        else
          Lozenge n+1, x,ly 
          T.div squareOptions[n].classNames, width:xpx,height:xpx, style: {backgroundColor:squareOptions[n].color,width:xpx,height:xpx}, ->
            T.div style: {WebkitTransformOrigin:'top left', WebkitTransform:"scale(#{shrink})",width:'711px',height:'711px'}, ->
              T.div "#sq-#{n}",onclick:"swap(#{n})",->
                squareOptions[n].src
                
  view: (vnode)=>
    collection = vnode.attrs.collection
    filter = vnode.attrs.filter || ()->true
    intermediate = collection.filter filter,@
    data = _(intermediate).sortBy( (s)->
      s.get 'category').groupBy (s) -> s.get 'category'
  
    teacupContent = Lozenge 0,x,y
    return teacupContent
