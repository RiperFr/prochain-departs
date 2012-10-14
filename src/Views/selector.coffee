class selector extends bb.View
  template: _.template """
    <div class="row-fluid selectorLine">
        <div class="span12 ">
            <h5>Liste des prochains trains au départ de </h5><select class="selectFrom"></select> <h5>en direction de</h5> <select class="selectTo"></select>
        </div>
    </div>
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

    optionFrom = document.createElement 'option'
    optionFrom.innerHTML = Station.get('name')
    optionFrom.value = Station.get('code')
    if Station.get('code') == @from
      $(optionFrom).attr("selected", "selected")
    @selectFrom.append(optionFrom)

    optionTo = document.createElement 'option'
    optionTo.innerHTML = Station.get('name')
    optionTo.value = Station.get('code')
    if Station.get('code') == @to
      $(optionTo).attr("selected", "selected")
    @selectTo.append(optionTo)

  refreshStations :=>
    @selectFrom.html '<option value="">Selectionez une gare</option>'
    @selectTo.html '<option value="">Toutes direction</option>'
    @stations.each  @appendStation

  setTrainFrom: (from)=>
    @from = from
    @refreshStations()
  setTrainTo: (to)=>
    @to = to
    @refreshStations()

  setTrainFromTo: (from,to) =>
    @from = from
    @to = to
    @refreshStations()

  selectChanged :=>
    if @selectFrom.val() == ''
      REGISTER.router.navigate('')
    else if @selectTo.val() == ''
      REGISTER.router.navigate('trains/from/'+@selectFrom.val())
    else
      REGISTER.router.navigate('trains/from/'+@selectFrom.val()+'/to/'+@selectTo.val())
  render : =>
    @.$el.html @template({})
    @selectFrom  = @.$('.selectFrom')
    @selectTo    = @.$('.selectTo')
    @refreshStations()

