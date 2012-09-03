class Controller extends Backbone.Router
    initialize: ->
        @view = new mainView
    routes :
        'trains/from/:from/to/:to' : 'trainsFromTo'

    trainsFromTo:(from,to) ->
        from = from.toUpperCase()
        to = to.toUpperCase()
        console.debug 'start'
        @trains.stop() unless @trains is undefined
        @trains = new TrainCollection null,
            from:from
            to:to
        @view.trainList.setTrainList @trains
        @view.trainList.refresh()
        @trains.start()
        console.dir @trains