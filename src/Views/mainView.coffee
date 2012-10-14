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
         """
    initialize: (options)->
        @config = options.config unless !options && !options.config
        _.bindAll @
        @render()
    render: ->
        @trainList = new trainList()
        @selector = new selector()
        @clock = new DigitalClock({noSeconds:true,display24h:true})
        $(@el).html @template({})
        @$('.list').append(@trainList.el)
        @$('.selector').append(@selector.el)
        @$('.digitalClock').append(@clock.el)


