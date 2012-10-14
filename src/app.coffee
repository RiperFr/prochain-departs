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