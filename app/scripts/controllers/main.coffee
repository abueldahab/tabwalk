"use strict"

onError = (error)->
  console.log error

angular.module("tapwalkdevApp").controller "MainCtrl", ($scope) ->

  userRating = Parse.Object.extend "UserRating"
  query = new Parse.Query userRating

  onSuccess = (data)->
    console.log data

  query.find
    success: onSuccess
    error: onError
