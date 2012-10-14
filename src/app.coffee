REGISTER = {}
init = =>
    REGISTER.router = new Controller
    Backbone.history.start({pushState: true, sessionStorage: true, root: window.location.pathname})

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


if window.WinJS
    WinJS.Binding.optimizeBindingReferences = true
    app = WinJS.Application
    activation = Windows.ApplicationModel.Activation

    app.onactivated = (args)->
        if args.detail.kind == activation.ActivationKind.launch
            if args.detail.previousExecutionState != activation.ApplicationExecutionState.terminated
                ##Just Started
                init()
                start()
            else
                #Just reactivated
                resume()
            args.setPromise(WinJS.UI.processAll())
    app.oncheckpoint = (args)->
        #Will be suspended*
        pause()
    app.start()
else
    $(document).ready =>
        init()
        start()