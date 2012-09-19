class trainList extends Backbone.View
    initialize: ->
        _.bindAll @
        @counter = 0
        @render()
    render: ->

        if @trainList
          $(@el).append '<ul></ul>'
          @trainList.each (Train)=>
              @appendTrain Train, @trainList
        else
          empty = new emptyList()
          $(@el).append empty.el


    refresh: =>
        console.debug 'reset view'
        $(@el).html ''
        @render()

    setTrainList : (collection)->
        # if a previous trainList exit, we disconnect the view from it.
        if @trainList then @trainList.unbind 'add', @appendTrain
        if @trainList then @trainList.unbind 'remove', @removeTrain
        if @trainList then @trainList.unbind 'reset', @refresh
        if collection isnt undefined
          @trainList = collection
          @trainList.bind 'add', @appendTrain
          @trainList.bind 'remove', @removeTrain
          @trainList.bind 'reset', @refresh
        else if @trainList
          @trainList = null

    clearTrainList : ->
      @trainList = null ;

    appendTrain :(Train,collection) =>
        if Train.view is undefined
           Train.view = new trainItem
                                model:Train
        $(@el).find('ul').first().append Train.view.el
    removeTrain : (Train,collection) =>
        Train.view.remove()