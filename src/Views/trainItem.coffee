class trainItem extends bb.View
    model     : Train
    nodeName  : 'li'
    template  : _.template "Template Item Train {{trainMissionCode}} of {{trainHour}}"
    initialize: ->
        @model.bind "change", @render
        @render()

    render: =>
        console.debug "Render train named #{@model.get('trainMissionCode')} at #{new Date().toString()}"
        @.$el.html @template(@model.toJSON())
        @
