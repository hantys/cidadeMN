map = undefined
myOptions = undefined
latlong = undefined
infoWindow = undefined
markers = []
categories = []
causaIds = []
select_cat = 0
panorama = undefined

@initMap = ->
  options_map()

  map = new google.maps.Map(document.getElementById("map"), myOptions)
  panorama = map.getStreetView()
  infoWindow = new (google.maps.InfoWindow)(map: map)
  geolocation_service()


@options_map = ->
  latlong = new google.maps.LatLng(-5.087242, -42.801805)
  myOptions =
    zoom: 13
    disableDoubleClickZoom: false
    zoomControl: true
    center: latlong
    mapTypeId: google.maps.MapTypeId.ROADMAP

    # controles do mapa

    mapTypeControl: true
    mapTypeControlOptions:
      style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR
      position: google.maps.ControlPosition.RIGHT_TOP

    panControl: true
    panControlOptions:
      position: google.maps.ControlPosition.RIGHT_CENTER

    zoomControl: true
    zoomControlOptions:
      style: google.maps.ZoomControlStyle.LARGE
      position: google.maps.ControlPosition.RIGHT_CENTER

    scaleControl: true
    scaleControlOptions:
      position: google.maps.ControlPosition.RIGHT_CENTER

    streetViewControl: true
    streetViewControlOptions:
      position: google.maps.ControlPosition.RIGHT_CENTER

    #fim controles do mapa

@geolocation_service = ->
  # Try HTML5 geolocation.
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition ((position) ->
      pos =
        lat: position.coords.latitude
        lng: position.coords.longitude
      infoWindow.setPosition pos
      infoWindow.setContent 'Você está aqui.'
      map.setCenter pos

    ), ->
      handleLocationError true, infoWindow, map.getCenter()

  else
    # Browser doesn't support Geolocation
    handleLocationError false, infoWindow, map.getCenter()

@handleLocationError = (browserHasGeolocation, infoWindow, pos) ->
  infoWindow.setPosition pos
  infoWindow.setContent if browserHasGeolocation then 'Erro: O servico de Geolocation falhou.' else 'Erro: Seu navegador não tem suporte para geolocation.'

jQuery ->
  console.log categories
  $.get "/categories.json", {}, (date) ->
    for c in date
      categories.push c
      console.log categories