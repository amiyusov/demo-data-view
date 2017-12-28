paginator = FlowComponents.define "paginator", ( params ) ->
  #log "paginator", params, params.itemsPerPage
  @set "itemsPerPageList", ["10", "20", "100"].map ( number ) ->
    id: number, text: number
  @set "itemsPerPage", +( params.itemsPerPage or itemsPerPage[0] )
  @set "totalItemsNumber", params.totalItemsNumber
  @set "page", params.page ? 0
#  @setFn "isFirstPage", => 1 is @get "page"
#  @setFn "isLastPage", => @get( "lastPage" ) is @get "page"
#  @setFn "lastPage", =>
#    ratio = @get( "totalItemsNumber" ) / @get( "itemsPerPage" )
#    lastPage = Math.floor ratio
#    lastPage++ if ratio > lastPage
#    lastPage

  if params.showItemsPerPageSelect
    @set "showItemsPerPageSelect", true
  @action = params.action

#########
# State #
#########

paginator.state.current = ->
  itemsPerPage = @get "itemsPerPage"
  page = @get "page"
  total = @get "totalItemsNumber"
  if total > 0
    firstOnPage = 1 + itemsPerPage * (page-1)
    lastOnPage = if @get "isLastPage" then total else ( page ) * itemsPerPage
    "#{firstOnPage}-#{lastOnPage}"
  else
    false

paginator.state.isFirstPage = ->
  1 is @get "page"

paginator.state.lastPage = ->
  ratio = @get( "totalItemsNumber" ) / @get( "itemsPerPage" )
  lastPage = Math.floor ratio
  lastPage++ if ratio > lastPage
  lastPage

paginator.state.isLastPage = ->
  @get( "lastPage" ) is @get "page"

###########
# Actions #
###########

paginator.action.goRight = ->
  page = @get( "page" ) + 1
  @set "page", page
  @action page, @get "itemsPerPage"

paginator.action.goLeft = ->
  page = @get( "page" ) - 1
  @set "page", page
  @action page, @get "itemsPerPage"

paginator.action.changeItemsPerPage = ( itemsPerPage ) ->
  itemsPerPage = parseInt itemsPerPage
  if (_.isNumber itemsPerPage) && itemsPerPage
    @set "page", 1
    @set "itemsPerPage", itemsPerPage
    @action 1, itemsPerPage
  else
    @set "itemsPerPage", 10
    @action 1, 10

##########
# Events #
##########

Template.paginator.events
  "click .js-go-right": -> FlowComponents.callAction "goRight"
  "click .js-go-left": -> FlowComponents.callAction "goLeft"
  "change [name='items-per-page']": ( ev ) ->
    FlowComponents.callAction "changeItemsPerPage", int10 $( ev.currentTarget ).val( )


