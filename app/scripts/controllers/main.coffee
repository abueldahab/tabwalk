"use strict"

onError = (error)->
  console.log error

controller = (scope)->

  userRating = Parse.Object.extend "UserRating"
  query = new Parse.Query userRating
  scope.entities = []

  onSuccess = (data)->
    console.log data
    scope.entities = data
    console.log scope.entities.length

  query.find
    success: onSuccess
    error: onError

angular.module("tapwalkdevApp")
  .controller "MainCtrl", ['$scope', controller]
