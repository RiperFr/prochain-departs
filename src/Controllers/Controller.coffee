class Controller extends bb.Router
    initialize: ->
        if  localStorage.configuration
            @config = new Configuration(localStorage.configuration)
        else
            @config = new Configuration()
        @config.bind 'change', @saveConfig
        @view = new mainView({config: @config})


    resume: =>
        if localStorage.from
            if localStorage.to and localStorage.to != 'null'
                @navigate("trains/from/#{localStorage.from}/to/#{localStorage.to}")
            else if localStorage.from and localStorage.from != 'null'
                @navigate("trains/from/#{localStorage.from}")
        @resumed = true

    saveConfig: =>
        localStorage.configuration = @config.toJSON()
    startTimer: =>
        @trains.stop() unless @trains is undefined or null
        @trains.start() unless @trains is undefined or null
        @timerStatus = true;

    stopTimer: =>
        @trains.stop() unless @trains is undefined or null
        @timerStatus = false

    _updateTimerRefs: (trains)=>
        if @timerStatus is true

            @stopTimer()
            @trains = trains
        else
            @trains = trains
        @startTimer()



    routes:
        ''                        : 'emptySelection'
        'trains/from/:from/to/:to': 'trainsFromTo'
        'trains/from/:from'       : 'trainsFrom'

    trainsFromTo: (from, to) =>
        if from == 'NULL'
            @emptySelection()
            return true
        if to == 'NULL'
            @trainsFrom(from)
            return true

        from = from.toUpperCase()
        to = to.toUpperCase()


        @stopTimer()
        trains = new TrainCollection null,
            from: from
            to  : to
        @view.trainList.setTrainList trains
        @view.selector.setTrainFromTo from, to
        @view.trainList.refresh()
        @_updateTimerRefs(trains)
        localStorage.from = from unless !@resumed
        localStorage.to = to unless !@resumed

    trainsFrom: (from) =>
        from = from.toUpperCase()
        if from == 'NULL'
            @emptySelection()
            return true
        @stopTimer()
        trains = new TrainCollection null,
            from: from
        @view.trainList.setTrainList trains
        @view.selector.setTrainFrom from
        @view.trainList.refresh()
        @_updateTimerRefs(trains)
        localStorage.from = from unless !@resumed
        localStorage.to = null unless !@resumed

    emptySelection: =>
        @view.trainList.setTrainList()
        @view.trainList.refresh()
        localStorage.from = null unless !@resumed
        localStorage.to = null unless !@resumed

