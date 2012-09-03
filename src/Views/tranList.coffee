class trainList extends Backbone.View
    initialize: ->
        _.bindAll @
        @counter = 0
        @render()
    render: ->
        $(@el).append '<ul></ul>'
        if @trainList
            @trainList.each (Train)=>
                @appendTrain Train, @trainList
        else
            console.debug "no trainList collection"

    refresh: =>
        console.debug 'reset view'
        $(@el).html ''
        @render()

    setTrainList : (collection)->
        # if a previous trainList exit, we disconnect the view from it.
        if @trainList then @trainList.unbind 'add', @appendTrain
        if @trainList then @trainList.unbind 'remove', @removeTrain
        if @trainList then @trainList.unbind 'reset', @refresh
        @trainList = collection
        @trainList.bind 'add', @appendTrain
        @trainList.bind 'remove', @removeTrain
        @trainList.bind 'reset', @refresh


    appendTrain :(Train,collection) =>
        if Train.view is undefined
            Train.view = new trainItem
                                model:Train
        $(@el).find('ul').first().append Train.view.el
    removeTrain : (Train,collection) =>
        Train.view.remove()