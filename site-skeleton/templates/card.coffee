#
# crd component
#
HalvallaCard = T.bless class cardComponent extends T.Component
  view: (card)=>  # T.render =>
    @image =card.image
    @shadow=card.shadow
    @headerText = card.headerText 
    @subHeaderText = card.subHeaderText
    @headerStyle = card.headerStyle
    @footerStyle = card.footerStyle
    @divider = card.headerDivider
    @footerItems = card.footerItems || []
    @text = card.text || card.content || ""
    @footerText = card.footerText
    classes = card.className?.replace /\s/g,'.'
    classes = '' unless classes?
    T.div "##{card.id}.#{classes}.u-#{@shadow}",=>
      T.img ".o-image", src: @image if @image
      if @headerText || @subHeaderText 
        T.header ".c-card__header",=>
          T.h2 ".c-heading c-heading--small",=>
            T.raw @headerText
            T.div ".c-heading__sub", @subHeaderText if @subHeaderText
      T.div ".c-card__item c-card__item#{'--'+card.header.style}" if @divider && ( @headerText || @subHeaderText)
      T.div ".c-card__body", =>
        T.div ".m1.bg-darken-1" ,@text
        #@children
      T.div ".c-card__item c-card__item{'--'+card.footer.style}" if @divider && ( @footerText || @footerItems.length >0 )
      T.footer ".c-card__footer",=>
        T.p ".c-text--quiet", @footerText if @footerText
        if @footerItems?.length>0
          T.div ".c-input-group", =>
            for b in @footerItems
              activity = '' + (b.active && 'c-button-active')
              style = "c.button--" + (b.style ||  '')
              T.button ".c-button.c-button--block.#{activity}#{style}"
