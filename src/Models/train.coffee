class Train extends bb.Model
    defaults:
        name : "name"
        mission : "Mission code"
        date : "dateTimeObject"
        lane: "plateform"

class TrainCollection extends Backbone.Collection
    model : Train
    initialize: (n,options)->
        if options isnt undefined
          @from = options.from unless options.from is undefined
          @to = options.to unless options.to is undefined
    url: =>
        if @to isnt undefined and @to isnt null and @to != 'NULL'
          "https://www.riper.fr/api/stif/trains/from/#{@from}/to/#{@to}?#{uniqid()}"
        else
          "https://www.riper.fr/api/stif/trains/from/#{@from}?#{uniqid()}"
    parse: (response,xhr)=>
        if xhr.status is 200 and response.status is true
            response.response
        else

            []
    cleanup: (ids) =>
        @.each (train)=>
            if _.indexOf(ids,train.get('id')) is -1 ##-1 mean not present
                log('One train has to be removed : '+train.get('trainMissionCode'));
                @remove train

    start: =>
        if @timer then clearInterval @timer
        @updateTrainList()
        @timer = setInterval @updateTrainList, 5000
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
                    log('Train refresh success');
                    @cleanup ids
                error : (n,reponse) =>
                    log('!!!!!!!!!!!!!! Train refresh Failure !!!!!!!!!!!!!');
                    @working = false