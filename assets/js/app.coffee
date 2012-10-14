class bb extends Backbone

class bb.Router extends Backbone.Router
  navigate: (str,options)=>
    if options is undefined then options = {}
    options.trigger = true
    Backbone.Router.prototype.navigate.call @,str,options

bb.history = Backbone.history

REGISTER = {}
init = =>
    REGISTER.router = new Controller
    Backbone.history.start({pushState : true,sessionStorage : true,root: window.location.pathname})

    hash = Backbone.history.getHash()
    if hash is ""
        #REGISTER.router.navigate('trains/from/EYO/to/PAZ', {trigger: true})

    else

    REGISTER.router.resume()


start = =>
  REGISTER.router.startTimer()

stop = =>
  REGISTER.router.stopTimer()

pause = =>
  REGISTER.router.stopTimer()

resume = =>
  REGISTER.router.startTimer()

$(document).ready =>
  init()
  start()

class Controller extends bb.Router
    initialize: ->
        if  localStorage.configuration
            @config = new Configuration(localStorage.configuration)
        else
            @config = new Configuration()
        @config.bind 'change',@saveConfig
        @view = new mainView({config:@config})


    resume: =>
        if localStorage.from
            if localStorage.to
                @navigate("trains/from/#{localStorage.from}/to/#{localStorage.to}")
            else
                @navigate("trains/from/#{localStorage.from}")
        @resumed = true

    saveConfig: =>
        localStorage.configuration = @config.toJSON()
    startTimer: =>
      @trains.stop() unless @trains is undefined or null
      @trains.start() unless @trains is undefined or null
      @timerStatus = true ;

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



    routes :
        ''                         : 'emptySelection'
        'trains/from/:from/to/:to' : 'trainsFromTo'
        'trains/from/:from'        : 'trainsFrom'

    trainsFromTo:(from,to) =>

        from = from.toUpperCase()
        to = to.toUpperCase()

        @stopTimer()
        trains = new TrainCollection null,
            from:from
            to:to
        @view.trainList.setTrainList trains
        @view.selector.setTrainFromTo from,to
        @view.trainList.refresh()
        @_updateTimerRefs(trains)
        localStorage.from = from unless !@resumed
        localStorage.to = to unless !@resumed

    trainsFrom:(from) =>

      from = from.toUpperCase()
      @stopTimer()
      trains = new TrainCollection null,
            from:from
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



class serviceContainers
    services:{}
    instances:{}

    register: (name,constructor) =>
        service :
            name : name
            constructor : constructor
        @services[name] = service

    get : (name)=>
        instance = new @services[name].constructor() unless @instances[name]
        #if instance then @instances[name] = instance
        @instances[name]





class zlog
    enabled: true
    enable : ->
        @enabled = true
    disable: ->
        @enabled = false

    debug: (text) ->

    dir: (obj) ->



class Configuration extends bb.Model
    defaults:
        theme:'dark'
        displayClock:true
        animate:true
    themeList:['dark','light']
    initialize : =>

        @.bind('change', @updateSettigns);
        @updateSettigns()
    updateSettigns: =>

        $('body').removeClass(theme) for theme in @themeList
        $('body').addClass(@.get('theme'));

class Station extends bb.Model
    defaults:
        code : "code"
        name : "name"
        location : {}


class StationsCollection extends Backbone.Collection
    model : Station
    initialize: (n,options)->

    url: =>
          "https://www.riper.fr/api/stif/stations"
    parse: (response,xhr)=>
        if xhr.status is 200 and response.status is true
            response.response
        else

            []
    comparator: (Station1,Station2)=>
      if Station1.get('name') == Station2.get('name') then return 0
      if(Station1.get('name')>Station2.get('name'))
        return 1
      else
        return -1


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
        if @to isnt undefined
          "https://www.riper.fr/api/stif/trains/from/#{@from}/to/#{@to}"
        else
          "https://www.riper.fr/api/stif/trains/from/#{@from}"
    parse: (response,xhr)=>
        if xhr.status is 200 and response.status is true
            response.response
        else

            []
    cleanup: (ids) =>
        @.each (train)=>
            if _.indexOf(ids,train.get('id')) is -1

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
                    @cleanup ids
                error : (n,reponse) =>
                    @working = false

class DigitalClock extends bb.View
  template: _.template """
              <div class="hours">00</div>
              <div class="dots dotsHour">:</div>
              <div class="minutes">00</div>
              <div class="dots dotsSeconds">:</div>
              <div class="seconds">00</div>
              <div class="milliseconds">00</div>
              <div class="ampm">am</div>
            """
  className: "digitalClock"
  initialize: (options)->
    options = {} unless options
    @interval = if options.displayMilli then 10 else 100 # if no milliseconds is displayed, it's not nessessary to update the clock so often
    @displayMilli = if options.displayMilli then true else false
    @display24h = if options.display24h then true else false
    @noSeconds = if options.noSeconds then true else false
    @$el.addClass(@className)
    @render()
    @start()

  start: =>
    clearInterval(@timer) unless @timer is undefined or null
    @timer = setInterval(@tick, @interval)
    @tick()
  stop: =>
    clearInterval(@timer) unless @timer is undefined or null

  render: =>
    @$el.html @template({})
    if @displayMilli is false then @$el.addClass 'noMilli'
    if @display24h is true then @$el.addClass 'display24h'
    if @noSeconds is true then @$el.addClass 'noSeconds'
    @nodes =
      hours: @$('.hours')
      minutes: @$('.minutes')
      seconds: @$('.seconds')
      milliseconds: @$('.milliseconds')
      ampm: @$('.ampm')
    @start()

  format: (number,format = 2)->
    result = ''+number
    if result.length <format
      neededZero = format-result.length
      for i in [1..neededZero]
        result = '0'+result
      result
    else
      result

  tick: =>
    date = new Date()
    if @display24h
      @nodes.hours.html @format date.getHours()
    else
      hours = date.getHours()
      @nodes.hours.html @format if hours > 12 then hours - 12 else hours
      @nodes.ampm.html @format if hours < 12 then "am" else "pm"

    @nodes.minutes.html @format date.getMinutes()
    @nodes.seconds.html @format date.getSeconds()
    @nodes.milliseconds.html  @format date.getMilliseconds(),3 unless @displayMilli is false

class emptyList extends bb.View
  template: _.template "Please make a selection"
  initialize : ->
    @render()

  render : =>
    @.$el.html @template({})

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




class selector extends bb.View
  template: _.template """
    <div class="row-fluid selectorLine">
        <div class="span12 ">
            <h5>Liste des prochains trains au départ de </h5><select class="selectFrom"></select> <h5>en direction de</h5> <select class="selectTo"></select>
        </div>
    </div>
  """
  initialize : ->

    @stations = new StationsCollection()
    @connect()
    @render()
    @stations.fetch()

  events:
    'change select' : 'selectChanged'
  connect : =>
    ##if @stations then @stations.unbind 'add', @appendStation
    if @stations then @stations.unbind 'reset', @refreshStations
    @stations.bind 'add', @appendStation
    @stations.bind 'reset', @refreshStations

  appendStation : (Station,collection)=>

    optionFrom = document.createElement 'option'
    optionFrom.innerHTML = Station.get('name')
    optionFrom.value = Station.get('code')
    if Station.get('code') == @from
      $(optionFrom).attr("selected", "selected")
    @selectFrom.append(optionFrom)

    optionTo = document.createElement 'option'
    optionTo.innerHTML = Station.get('name')
    optionTo.value = Station.get('code')
    if Station.get('code') == @to
      $(optionTo).attr("selected", "selected")
    @selectTo.append(optionTo)

  refreshStations :=>
    @selectFrom.html '<option value="">Selectionez une gare</option>'
    @selectTo.html '<option value="">Toutes direction</option>'
    @stations.each  @appendStation

  setTrainFrom: (from)=>
    @from = from
    @refreshStations()
  setTrainTo: (to)=>
    @to = to
    @refreshStations()

  setTrainFromTo: (from,to) =>
    @from = from
    @to = to
    @refreshStations()

  selectChanged :=>
    if @selectFrom.val() == ''
      REGISTER.router.navigate('')
    else if @selectTo.val() == ''
      REGISTER.router.navigate('trains/from/'+@selectFrom.val())
    else
      REGISTER.router.navigate('trains/from/'+@selectFrom.val()+'/to/'+@selectTo.val())
  render : =>
    @.$el.html @template({})
    @selectFrom  = @.$('.selectFrom')
    @selectTo    = @.$('.selectTo')
    @refreshStations()



class trainItem extends bb.View
    model     : Train
    nodeName  : 'div'
    className: 'row-fluid trainLine'
    template  : _.template """
                <div class="span2 trainCode">{{trainMissionCode}}</div>
                <div class="span2 trainMention">{{trainMention}}&nbsp;</div>
                <div class="span1 trainTime">{{time}}</div>
                <div class="span6 trainDestination">{{trainTerminusName}}</div>"""
    initialize: ->
        @model.bind "change", @render
        @render()

    render: =>


        obj = @model.toJSON()
        if obj.trainMention == null then obj.trainMention = ""
        if obj.trainMention != '' then @.$el.addClass('hasMention') else @.$el.removeClass('hasMention')
        if obj.trainMention == '' and obj.trainLane then obj.trainMention = obj.trainLane
        obj.time = obj.trainHour.split(' ')[1]

        @.$el.html @template(obj)
        @


class trainList extends bb.View
    initialize: ->
        _.bindAll @
        @counter = 0
        @render()
    className:"row-fluid trainList"
    render: ->

        if @trainList
          $(@el).append '<div class="span12"></div>'
          @trainList.each (Train)=>
              @appendTrain Train, @trainList

        else
          empty = new emptyList()
          $(@el).append empty.el


    refresh: =>

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
        @trainList = null

    appendTrain :(Train,collection) =>
        if Train.view is undefined
           Train.view = new trainItem
                                model:Train
        $(@el).find('div').first().append Train.view.el
    removeTrain : (Train,collection) =>
        Train.view.remove()