class emptyList extends bb.View
  template: _.template "Please make a selection"
  initialize : ->
    @render()

  render : =>
    @.$el.html @template({})