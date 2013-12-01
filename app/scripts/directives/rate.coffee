'use strict'

controller = (scope) ->
  scope.complete = Math.floor(scope.rate)
  scope.empty = 5 - Math.ceil(scope.rate)
  scope.partial = Math.round((scope.rate - scope.complete) * 10) * 10

  scope.starOf = (rate)->
    "http://tapwalk.com/leaderboard/star_#{rate}.png"

angular.module('tapwalkdevApp')
  .directive 'rate', ->
    templateUrl: 'views/rate.html'
    restrict: 'E'
    scope:
      rate: '=value'
    controller:  ['$scope', controller]

