start = =>
    router = new Controller
    Backbone.history.start({})
    hash = Backbone.history.getHash()
    if hash is ""
        router.navigate('trains/from/EYO/to/PAZ', {trigger: true})
        console.debug "change the fragment  of #{hash}"
    else
        console.debug "Already a fragment of #{hash}"

$(document).ready(start)