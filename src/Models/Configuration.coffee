class Configuration extends bb.Model
    defaults:
        theme:'dark'
        displayClock:true
        animate:true
    themeList:['dark','light']
    initialize : =>
        console.debug('initConfig')
        @.bind('change', @updateSettigns);
        @updateSettigns()
    updateSettigns: =>
        console.debug('update settings');
        $('body').removeClass(theme) for theme in @themeList
        $('body').addClass(@.get('theme'));