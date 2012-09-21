class Controller extends bb.Router
    initialize: ->
        @view = new mainView

    startTimer: =>
      @trains.stop() unless @trains is undefined or null
      @trains.start() unless @trains is undefined or null
      @timerStatus = true ;

    stopTimer: =>
      @trains.stop() unless @trains is undefined or null
      @timerStatus = false

    _updateTimerRefs: (trains)=>
      if @timerStatus is true
        console.debug 'restart timer'
        @stopTimer()
        @trains = trains
      else
        console.debug 'timer never started'
        @trains = trains
      @startTimer()



    routes :
        ''                         : 'emptySelection'
        'trains/from/:from/to/:to' : 'trainsFromTo'
        'trains/from/:from'        : 'trainsFrom'

    trainsFromTo:(from,to) =>
        console.debug 'from to'
        from = from.toUpperCase()
        to = to.toUpperCase()
        console.debug 'start'
        @stopTimer()
        trains = new TrainCollection null,
            from:from
            to:to
        @view.trainList.setTrainList trains
        @view.selector.setTrainFromTo from,to
        @view.trainList.refresh()
        @_updateTimerRefs(trains)

    trainsFrom:(from) =>
      console.debug 'from only'
      from = from.toUpperCase()
      @stopTimer()
      trains = new TrainCollection null,
            from:from
      @view.trainList.setTrainList trains
      @view.selector.setTrainFrom from
      @view.trainList.refresh()
      @_updateTimerRefs(trains)

    emptySelection: =>
      @view.trainList.setTrainList()
      @view.trainList.refresh()

