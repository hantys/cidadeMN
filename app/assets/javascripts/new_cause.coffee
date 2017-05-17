jQuery ->
  point = null
  fenway = new google.maps.LatLng(parseFloat(-5.087242), parseFloat(-42.801805))
  local = new google.maps.LatLng(parseFloat(-5.087242), parseFloat(-42.801805))
  unless $('#cause_latitude').val() == '' and $('#cause_longitude').val() == ''
    local = new google.maps.LatLng($('#cause_latitude').val(), $('#cause_longitude').val())
    point = new google.maps.LatLng($('#cause_latitude').val(), $('#cause_longitude').val())
    fenway = new google.maps.LatLng($('#cause_latitude').val(), $('#cause_longitude').val())

  myOptions2 =
    zoom: 15
    disableDoubleClickZoom: true
    zoomControl: true
    center: local
    mapTypeId: google.maps.MapTypeId.ROADMAP

    zoomControlOptions:
      style: google.maps.ZoomControlStyle.LARGE

  panoramaOptions =
    position: fenway
    zoomControlOptions:
      style: google.maps.ZoomControlStyle.LARGE
    pov:
      heading: 265
      pitch: 0

  #### mapa
  map = new google.maps.Map(document.getElementById("#show_maps_canvas"), myOptions2)

  #### streatview
  panorama = new google.maps.StreetViewPanorama(document.getElementById("#pano"), panoramaOptions)

  map.setStreetView panorama

  marker2 = new google.maps.Marker(
    position: point
    map: map
    title: "123"
  )
  marker1 = new google.maps.Marker(
    position: point
    map: panorama
    title: "1232"
  )

  infowindow = new google.maps.InfoWindow(
    content: "Sua propaganda esta aqui"
    size: new google.maps.Size(50, 50)
  )

  google.maps.event.addListener map, "click", (event) ->
    placeMarker event.latLng

  msg_marker = (marker) ->
    google.maps.event.addListener marker, "click", (event) ->
      infowindow.open marker.get("map"), marker

  placeMarker = (location) ->
    marker1.setMap null
    marker2.setMap null

    marker1 = new google.maps.Marker(
      position: location
      map: panorama
    )
    marker2 = new google.maps.Marker(
      position: location
      map: map
    )
    msg_marker(marker2)
    msg_marker(marker1)
    panorama.setPosition(location)
    atualiza_position(location)


    # To add the marker to the map, call setMap();
  marker2.setMap map

  atualiza_position = (location) ->
  # as variaveis do location 'Ya' e 'Za' referentes as coordenadas mudam de acordo com o projeto
    $('#cause_latitude').val "#{location.lat()}"
    $('#cause_longitude').val "#{location.lng()}"
    $(".alerta-atual").show('clip')
    $(".alerta-atual").text('Pin Atualizado!')
    setTimeout (->
      $(".alerta-atual").hide('clip')
      ), 1500