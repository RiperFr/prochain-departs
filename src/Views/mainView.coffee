class mainView extends bb.View
    el:$ '#mainView'
    template: _.template """
        <div class="row-fluid">
            <div class="span12 selector"></div>
        </div>
        <div class="row-fluid">
            <div class="span12 list"></div>
        </div>
        <div class="digitalClock"></div>
        <div class="themeSelector"></div>
         """
    initialize: (options)->
        @config = options.config
        _.bindAll @
        @render()
    updateTheme: ()=>
        if $('.themeSelector input[type="checkbox"]').is(':checked')
            @config.set({theme:'light'})
        else
            @config.set({theme:'dark'})
    render: ->
        @trainList = new trainList()
        @selector = new selector()
        @clock = new DigitalClock({noSeconds:true,display24h:true})
        $(@el).html @template({})
        @$('.list').append(@trainList.el)
        @$('.selector').append(@selector.el)
        @$('.digitalClock').append(@clock.el)
        if if window.WinJS
            MSApp.execUnsafeLocalFunction ()->
                $('.themeSelector').html('<input type="checkbox" name="light" value="1" >')
        else
            $('.themeSelector').html('<input type="checkbox" name="light" value="1" >')

        if @config.get('theme') == 'light'
            $('.themeSelector input[type="checkbox"]').attr('checked',true);
        $('.themeSelector input[type="checkbox"]').bind('change',@updateTheme)



