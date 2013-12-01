"use strict"

onError = (error)->
  console.log error

controller = (scope, ngTableParams, $filter)->

  userRating = Parse.Object.extend "UserRating"
  query = new Parse.Query userRating
  scope.entities = []

  onSuccess = (data)->
    initTable()
    scope.entities = data

  getData = ->
    scope.entities or []

  initTable = ->
    scope.tableParams = new ngTableParams(
      page: 1 # show first page
      count: 10 # count per page
      sorting:
        datetime: 'desc'
    ,
      total: ->
        getData().length # length of data
      getData: ($defer, params) ->
        #$defer.resolve data.slice((params.page() - 1) * params.count(), params.page() * params.count())
        data = getData()
        orderedData = (if params.filter() then $filter("filter")(data, params.filter()) else data)
        scope.list = orderedData?.slice((params.page() - 1) * params.count(), params.page() * params.count())
        params.total orderedData?.length # set total for recalc pagination
        $defer.resolve scope.list
      scope: {$data: {}}
    )


  load = ->
    Service.list (data)->
      scope.data = JSON.parse data
      initTable()

    query.find
      success: onSuccess
      error: onError

  load()


angular.module("tapwalkdevApp")
  .controller "MainCtrl", ['$scope', 'ngTableParams', '$filter', controller]
