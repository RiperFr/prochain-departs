class mainView extends Backbone.View
    el:$ 'body'
    initialize: ->
        _.bindAll @
        @render()
    render: ->
        @trainList = new trainList
        $(@el).append(@trainList.el)