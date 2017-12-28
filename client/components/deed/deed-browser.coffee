_ = lodash
deedBrowser = FlowComponents.define "deedBrowser", ->

  @set "totalItemsCount", 0
  @set "totalFilteredItemsCount", 0
  @set "currentItemsCount", 0
  @set "pageNumber", 1
  @set "pageSize", 10
  @set "tableLabel", "Deed browser"
  @set "columnsList", []
  @set "displayData", []
  @set "sort", {}

  Meteor.call "Deed.getCount", (err, count) =>
    @set "totalItemsCount", count
    @set "totalFilteredItemsCount", count

  Meteor.call "Deed.getColumns", (err, columns) =>
    colsObjcts = (@initColumnObject column for column in columns)
    for idx in [0..10]
      colsObjcts[idx] = _.extend colsObjcts[idx], visible: true
    @set "columnsList", colsObjcts
    @loadData()

##############################################################################
#
#                                PROTOTYPE
#
##############################################################################

deedBrowser::initColumnObject = (columnName) ->
  label: columnName,
  name: columnName,
  visible: false,
  sort: false,
  filter: false

deedBrowser::updateColumn = (name, prop, val) ->
  cols = @get "columnsList"
  idx = _.findIndex cols, {name}
  unless idx < 0
    cols[idx][prop] = val
    @set "columnsList", cols

deedBrowser::updateTotalFilteredItemsCount = ->
  Meteor.call "Deed.getCount", @getLoadFieldsParams().filters,(err, count) =>
    @set "totalFilteredItemsCount", count

deedBrowser::loadData = ->
  methodParams = _.extend {
    pageSize: (@get "pageSize"), pageNumber: (@get "pageNumber")
  }, @getLoadFieldsParams()

  Meteor.call "Deed.getData", methodParams, (err, result) =>
    @set "displayData", result


deedBrowser::getLoadFieldsParams = ->
  fields = []
  sort = @get "sort"
  filters = {}
  for column in @get "columnsList" when column.visible
    fields.push column.name
    if column.filter then filters[column.name] = column.filter

  {fields, sort, filters}


##############################################################################
#
#                                ACTIONS
#
##############################################################################

deedBrowser.action.changeColumnVisibility = (name, visible) ->
  @updateColumn name, "visible", visible

deedBrowser.action.changeColumnSort = (name, sort) ->
  console.log "changeColumnSort", arguments
  @set "sort", {"#{name}": sort}
  @loadData()

deedBrowser.action.setPagination = (pageNumber, pageSize) ->
  @set "pageNumber", pageNumber
  @set "pageSize", pageSize
  @loadData()

deedBrowser.action.setFilter = (field, value) ->
  @updateColumn field, "filter", value
  @loadData()
  @updateTotalFilteredItemsCount()

##############################################################################
#
#                                EVENTS
#
##############################################################################

Template.deedBrowser.events

  "click .sort-asc": ( ev, tpl ) ->
    FlowComponents.callAction "changeColumnSort", @name, "ASC"
  "click .sort-desc": ( ev, tpl ) ->
    FlowComponents.callAction "changeColumnSort", @name, "DESC"


  "click .js-hide-tbody": ( ev, tpl ) ->
    tpl.$( ".js-tronic-table-tbody" ).toggleClass "hidden"
    tpl.$( ".js-columns-selector" ).toggleClass "hidden"

# columns selecor
  "change .js-col-selector": ( ev, tpl ) ->
    FlowComponents.callAction "changeColumnVisibility", @name, ev.target.checked



##############################################################################
#
#                                TEMPLATE HELPERS
#
##############################################################################

Template.deedBrowser.helpers
  checkedAttr: (visible) ->
    "checked" if visible

## sort
  sortClass: ( column, currentSort ) ->

    direction = currentSort[column.name]

    switch direction
      when "ASC" then "ascending sort-desc"
      when "DESC" then  "descending sort-asc"
      else "no-sort sort-asc"


  getProperty: (data, property) ->
    data[property]
