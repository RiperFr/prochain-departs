class Train extends Backbone.Model
    defaults:
        name : "name"
        mission : "Mission code"
        date : "dateTimeObject"
        lane: "plateform"

class TrainCollection extends Backbone.Collection
    model : Train
    initialize: (n,options)->
        console.debug 'initialize collection'
        @from = options.from unless options is undefined
        @to = options.to unless options is undefined
    url: =>
        "https://www.riper.fr/api/stif/trains/from/#{@from}/to/#{@to}"
    parse: (response,xhr)=>
        if xhr.status is 200 and response.status is true
            response.response
        else
            console.debug 'Error in response from server with parameters '+"#{@from}/#{@to}"
            []
    cleanup: (ids) =>
        console.debug "cleanup"
        console.debug @models.length

        @.each (train)=>
            console.dir  _.indexOf ids,train.get('id')
            if _.indexOf(ids,train.get('id')) is -1
                console.debug "Train is outdated #{train.get('trainMissionCode')}"
                @remove train

    start: =>
        if @timer then clearInterval @timer
        @updateTrainList()
        @timer = setInterval @updateTrainList, 2000
    stop: =>
        if @timer then clearInterval @timer

    updateTrainList : =>
        if @working isnt true
            @working = true
            @fetch
                add : true
                success: (n,response)=>
                    @working = false
                    ids = _.pluck response.response,'id'
                    @cleanup ids
                error : (n,reponse) =>
                    @working = false