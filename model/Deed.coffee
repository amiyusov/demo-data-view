@Deed = new Mongo.Collection "20171113_DeedMtg-Deed06067.txt"


if Meteor.isServer

##############################################################################
#
#                                HELPERS
#
##############################################################################

  _getProjectionFromFields = (fields = []) ->
    projection = {}
    for field in fields
      projection[field] = 1

    projection

  _getSelectorFromFilters = (filters) ->
    selector = {}
    for field, value of filters
      selector[field] = {$regex: value, $options: "i"}

    selector

  _processSort = (sorters) ->
    sort = []
    for field, direction of sorters
      sort.push [field, if direction is "ASC" then "asc" else "desc"]

    sort

  _getOpts = (pageSize, pageNumber, fields, sort) ->
    {
      fields: _getProjectionFromFields fields
      skip: (pageNumber-1)*pageSize
      limit: pageSize
      sort: _processSort sort
    }


  ##############################################################################
  #
  #                                METHODS
  #
  ##############################################################################

  Meteor.methods
    "Deed.getCount": (filters) ->
      console.log(_getSelectorFromFilters filters)
      Deed.find _getSelectorFromFilters filters
        .count()

    "Deed.getColumns": ->
      _.keys Deed.findOne({})

    "Deed.getData": ({pageSize = 10,pageNumber = 1,fields,sort,filters}) ->

      selector = _getSelectorFromFilters filters
      options = _getOpts pageSize, pageNumber, fields, sort

      Deed.find selector, options
        .fetch()
