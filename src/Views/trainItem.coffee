class trainItem extends bb.View
    model     : Train
    nodeName  : 'div'
    className: 'row-fluid trainLine'
    template  : _.template """
                <div class="span2 trainCode">{{trainMissionCode}}</div>
                <div class="span2 trainMention">{{trainMention}}&nbsp;</div>
                <div class="span1 trainTime">{{time}}</div>
                <div class="span6 trainDestination">{{trainTerminusName}}</div>"""
    initialize: ->
        @model.bind "change", @render
        @render()

    render: =>
        console.debug "Render train named #{@model.get('trainMissionCode')} at #{new Date().toString()}"

        obj = @model.toJSON()
        if obj.trainMention == null then obj.trainMention = ""
        if obj.trainMention != '' then @.$el.addClass('hasMention') else @.$el.removeClass('hasMention')
        if obj.trainMention == '' and obj.trainLane then obj.trainMention = obj.trainLane
        obj.time = obj.trainHour.split(' ')[1]

        @.$el.html @template(obj)
        @
