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
  povoa_categoria()

@povoa_categoria = ->
  centro = map.getCenter()
  $.get "/causes.json", {lat: centro.lat(), lng: centro.lng(), category: select_cat}, (data) ->
    i = -1
    $(data).each (index, causa) ->
      local = new google.maps.LatLng(parseFloat(causa.latitude), parseFloat(causa.longitude))
      povoa_map causa, local

    panorama.setPov (
      heading: 265
      pitch: 0
    )


@povoa_map= (causa, local) ->
  img = recursive_category causa.category_id
  icon = new google.maps.MarkerImage img
  marker = placeMarker local

  marker.addListener('click' , openCauseWindow(marker, causa.id))
  marker.setIcon icon
  causaIds.push(causa.id)
  markers.push(marker)


@placeMarker = (location) ->
  #marker.setMap null
  marker = new google.maps.Marker(
    # animation: google.maps.Animation.DROP
    position: location
    map: map
  )


@openCauseWindow = (marker, causa) ->
  return ( ->
    $("#modal-css").html "Carregando..."
    $('#myModal').modal('toggle')
    jqxhr = $.get("/show_causa/#{causa}", (data) ->
      $(".render").html("")
      $(".render").html data

      open_next(marker)
    ).done(->
    ).fail(->
      $(".render").html "ERRO na requisição!"
    ).always(->
    )
  )

@open_next= (marker) ->
  $('.causa_proxima').click ->
    id = $(this).attr('data-id')
    $("#modal-css").html "Carregando..."
    jqxhr = $.get("/show_causa/#{id}", (data) ->
      $(".render").html("")
      $(".render").html data

      open_next(marker)
    ).done(->
    ).fail(->
      $(".render").html "ERRO na requisição!"
    ).always(->
    )

@recursive_category= (id) ->
  for c in categories
    if c.id == id
      return c.icon.url

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
  $.get "/categories.json", {}, (date) ->
    for c in date
      categories.push c
