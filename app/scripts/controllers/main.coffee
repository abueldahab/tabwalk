"use strict"

onError = (error)->
  console.log error

controller = (scope, ngTableParams, $filter)->

  userRating = Parse.Object.extend "UserRating"
  query = new Parse.Query userRating
  scope.entities = []

  onSuccess = (data)->
    scope.entities = data
    scope.ratingsTable.reload()
    console.log scope.entities

  getData = ->
    scope.entities or []

  initTable = ->
    scope.ratingsTable = new ngTableParams(
      page: 1 # show first page
      count: 10 # count per page
      sorting:
        datetime: 'desc'
    ,
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
    )


  load = ->
    query.find
      success: onSuccess
      error: onError

  load()
  initTable()


angular.module("tapwalkdevApp")
  .controller "MainCtrl", ['$scope', 'ngTableParams', '$filter', controller]
