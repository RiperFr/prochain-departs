class Station extends bb.Model
    defaults:
        code : "code"
        name : "name"
        location : {}


class StationsCollection extends Backbone.Collection
    model : Station
    initialize: (n,options)->

    url: =>
          "https://www.riper.fr/api/stif/stations"
    parse: (response,xhr)=>
        if xhr.status is 200 and response.status is true
            response.response
        else

            []
    comparator: (Station1,Station2)=>
      if Station1.get('name') == Station2.get('name') then return 0
      if(Station1.get('name')>Station2.get('name'))
        return 1
      else
        return -1
