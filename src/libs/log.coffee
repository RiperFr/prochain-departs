class zlog
    enabled: true
    enable : ->
        @enabled = true
    disable: ->
        @enabled = false

    debug: (text) ->
        console.debug(text) unless @enabled != true
    dir: (obj) ->
        console.dir(obj) unless @enabled != true
