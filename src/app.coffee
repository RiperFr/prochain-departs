REGISTER = {}
init = =>
    REGISTER.router = new Controller
    Backbone.history.start({})
    hash = Backbone.history.getHash()
    if hash is ""
        #REGISTER.router.navigate('trains/from/EYO/to/PAZ', {trigger: true})
        console.debug "change the fragment  of #{hash}"
    else
        console.debug "Already a fragment of #{hash}"



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