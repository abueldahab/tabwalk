"use strict"

onError = (error)->
  console.log error

controller = (params, scope, ngTableParams, $filter, timeout)->

  venueUid = parseInt params.venue, 10
  fromRank = parseFloat params.from
  toRank = parseFloat params.to
  refreshSeconds = 1000 * parseInt(params.refresh, 10)
  console.log params.pagination.toLowerCase()
  pagination = params.pagination.toLowerCase() == 'yes'
  console.log pagination

  userRating = Parse.Object.extend "UserRating"
  query = new Parse.Query userRating
  query.equalTo 'venueUid', venueUid
  scope.entities = []

  scope.availableRatings = (parseFloat(x.toFixed(1)) for x in [1.0..5.0] by 0.1)

  alter = (data)->
    results = {}
    _.each data, (e)->
      key = e.get('objectType') + e.get('uid')
      unless results[key]
        results[key] =
          venueUid: e.get('venueUid')
          title: e.get('title')
          rating: e.get('rating')
          ratings: [e.get('rating')]
          uid: e.get('uid')
          userDevices: [e.get('userDeviceId')]
      else
        o = results[key]
        o.ratings.push e.get('rating')
        o.userDevices.push e.get('userDeviceId')  unless e.get('userDeviceId') in o.userDevices
        o.rating = _.reduce(o.ratings, (a,b)-> a+b) / o.ratings.length
        o.rating = parseFloat o.rating.toFixed(1)

    data = _.values results
    data = _.sortBy(data, 'rating').reverse()
    lastRating = -1
    lastRank = 1
    data = _.map data, (e, i)->
      if e.rating is lastRating
        e.rank = lastRank
      else
        e.rank = i + 1
        lastRating = e.rating
        lastRank = e.rank
      e

    data = _.filter data, (e)->
      fromRank <= e.rank <= toRank

    scope.rates = 0
    userDevicesElements = []
    _.each data, (e)->
      scope.rates += e.ratings.length
      userDevicesElements = userDevicesElements.concat(e.userDevices)

    scope.userDevices = _.uniq(userDevicesElements).length
    return data

  onSuccess = (data)->
    scope.entities = alter data
    scope.ratingsTable.reload()

  getData = ->
    scope.entities or []

  initTable = ->
    params =
      page: 1 # show first page
      count: 10 # count per page
      sorting:
        datetime: 'desc'

    settings =
      total: ->
        getData().length # length of data

      getData: ($defer, params) ->
        data = getData()
        orderedData = (if params.filter() then $filter("filter")(data, params.filter()) else data)
        scope.list = orderedData?.slice((params.page() - 1) * params.count(), params.page() * params.count())
        # set total for recalc pagination
        params.total orderedData?.length
        $defer.resolve scope.list

      scope: {$data: {}}

    unless pagination
      settings.counts= ->[]

    scope.ratingsTable = new ngTableParams(params, settings)


  load = ->
    query.find
      success: onSuccess
      error: onError

  load()
  initTable()

  reloader = ->
    timeout(reloader, refreshSeconds)
    console.log 'reloading...'
    load()

  reloader()


angular.module("tapwalkdevApp")
  .controller "MainCtrl",
  ['$routeParams', '$scope', 'ngTableParams', '$filter', '$timeout', controller]
