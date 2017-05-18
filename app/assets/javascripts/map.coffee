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
  google.maps.event.addListener map, "dblclick", (event) ->
    window.location.href = '/causes/new'
  geolocation_service()
  povoa_categoria()

@filter_category = (id) ->
  remove_markes()
  causaIds = []
  select_cat = id
  povoa_categoria()

@remove_markes = () ->
  for local in markers
    local.setMap null

@povoa_categoria = ->
  centro = map.getCenter()
  $.get "/find_causes", {lat: centro.lat(), lng: centro.lng(), category: select_cat}, (data) ->
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
    disableDoubleClickZoom: true
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
      local = new google.maps.LatLng(parseFloat(position.coords.latitude), parseFloat(position.coords.longitude))
      marker = placeMarker local
      map.setCenter local

    ), ->
      local = new google.maps.LatLng(parseFloat(-5.087242), parseFloat(-42.801805))
      marker = placeMarker local
      map.setCenter local
  else
    local = new google.maps.LatLng(parseFloat(-5.087242), parseFloat(-42.801805))
    marker = placeMarker local
    map.setCenter local

jQuery ->
  $.get "/categories.json", {}, (date) ->
    for c in date
      categories.push c


#Menu Sidebar

@menu = ->
  $('.nav-toggle').click ->
    if $('.nav-filter').hasClass('side-fechado')
      $('.nav-filter').animate { left: '15px' }, 100, ->
        $('.nav-filter').removeClass 'side-fechado'
        $('#arrow-menu').removeClass 'glyphicon glyphicon-triangle-bottom'
        $('#arrow-menu').addClass 'glyphicon glyphicon-triangle-top'
    else
      $('.nav-filter').animate { left: '-106px' }, 100, ->
        $('.nav-filter').addClass 'side-fechado'
        $('#arrow-menu').removeClass 'glyphicon glyphicon-triangle-top'
        $('#arrow-menu').addClass 'glyphicon glyphicon-triangle-bottom'

$(window).resize ->
  tamanhoJanela = $(window).width()
  $('.nav-toggle').remove()
  if tamanhoJanela < 1400
    $('.nav-filter').css('left', '-106px').addClass 'side-fechado'
    $('.nav-filter').append '<div class=\'nav-toggle\'> <i id=\'arrow-menu\' class=\'glyphicon glyphicon-triangle-bottom\' ></i> Filtrar Categoria</div>'
  else
    $('.nav-filter').css('left', '0').addClass 'side-fechado'
  menu()
$(document).ready ->
  tamanhoJanela = $(window).width()
  $('.nav-toggle').remove()
  if tamanhoJanela < 1400
    $('.nav-filter').css('left', '-106px').addClass 'side-fechado'
    $('.nav-filter').append '<div class=\'nav-toggle\'> <i id=\'arrow-menu\' class=\'glyphicon glyphicon-triangle-bottom\' ></i> Filtrar Categoria</div>'
  else
    $('.nav-filter').css('left', '0').addClass 'side-fechado'
  menu()

