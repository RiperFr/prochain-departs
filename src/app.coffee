REGISTER = {}
init = =>
    REGISTER.router = new Controller
    Backbone.history.start({pushState: true, sessionStorage: true, root: window.location.pathname})
    log('Initialising the app');
    hash = Backbone.history.getHash()
    if hash is ""
        #REGISTER.router.navigate('trains/from/EYO/to/PAZ', {trigger: true})

    else

    REGISTER.router.resume()


start = =>
    log('Starting the app');
    REGISTER.router.startTimer()

stop = =>
    log('Stopping the app');
    REGISTER.router.stopTimer()

pause = =>
    log('Pausing the App');
    REGISTER.router.stopTimer()

resume = =>
    log('Resuming the app');
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

    webapp = Windows.UI.WebUI.WebUIApplication;
    webapp.addEventListener("resuming", resume, false);
    app.start()
else
    $(document).ready =>
        init()
        start()