class Configuration extends bb.Model
    defaults:
        theme:'light'
        displayClock:true
        animate:true
    themeList:['dark','light']
    initialize : =>

        @.bind('change', @updateSettigns);
        @updateSettigns()
    updateSettigns: =>

        $('body').removeClass(theme) for theme in @themeList
        $('body').addClass(@.get('theme'));