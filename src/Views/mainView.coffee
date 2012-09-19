class mainView extends Backbone.View
    el:$ 'body'
    template: _.template """
      <div class="selector"></div>
      <div class="list"></div>
        """
    initialize: ->
        _.bindAll @
        @render()
    render: ->
        @trainList = new trainList()
        @selector = new selector()
        $(@el).html @template({})
        @$('.list').append(@trainList.el)
        @$('.selector').append(@selector.el)
