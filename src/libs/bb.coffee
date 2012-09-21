class bb extends Backbone

class bb.Router extends Backbone.Router
  navigate: (str,options)=>
    if options is undefined then options = {}
    options.trigger = true
    Backbone.Router.prototype.navigate.call @,str,options

bb.history = Backbone.history