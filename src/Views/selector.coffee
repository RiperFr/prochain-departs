class selector extends Backbone.View
  template: _.template """
  Prochains départs de <select class="selectFrom"></select> à <select class="selectTo"></select>
  """
  initialize : ->
    @stations = new StationsCollection()
    @connect()
    @render()
    @stations.fetch()

  events:
    'change select' : 'selectChanged'
  connect : =>
    ##if @stations then @stations.unbind 'add', @appendStation
    if @stations then @stations.unbind 'reset', @refreshStations
    @stations.bind 'add', @appendStation
    @stations.bind 'reset', @refreshStations

  appendStation : (Station,collection)=>
    console.debug 'append stations'
    optionFrom = document.createElement 'option'
    optionFrom.innerHTML = Station.get('name')
    optionFrom.value = Station.get('code')
    @selectFrom.append(optionFrom)

    optionTo = document.createElement 'option'
    optionTo.innerHTML = Station.get('name')
    optionTo.value = Station.get('code')
    @selectTo.append(optionTo)

  refreshStations :=>
    @selectFrom.html '<option value="">Selectionez une gare</option>'
    @selectTo.html '<option value="">Toutes direction</option>'
    @stations.each  @appendStation


  selectChanged :=>
    if @selectFrom.val() == ''
      REGISTER.router.navigate('',{trigger: true})
    else if @selectTo.val() == ''
      REGISTER.router.navigate('trains/from/'+@selectFrom.val(), {trigger: true})
    else
      REGISTER.router.navigate('trains/from/'+@selectFrom.val()+'/to/'+@selectTo.val(), {trigger: true})
  render : =>
    @.$el.html @template({})
    @selectFrom  = @.$('.selectFrom')
    @selectTo    = @.$('.selectTo')
    @refreshStations()

