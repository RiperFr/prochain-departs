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