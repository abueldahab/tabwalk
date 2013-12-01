"use strict"
config = ($routeProvider, $compileProvider) ->

  Parse.initialize "xAONBeHiD8bBeKSdpRExCDCEbQWY8gENyPO0hP5q",
                   "pwxKwWdssyPJf2bA7WvIFJ6mvQeGFCgtqGTbns0m"

  $routeProvider.when "/:venue/:from/:to/:refresh",
    templateUrl: "views/main.html"
    controller: "MainCtrl"

  #).otherwise redirectTo: "/"


app = angular.module("tapwalkdevApp", ['ngRoute', 'ngTable'])
app.config config

rootController = (root, location)->

  root.go = (url)->
    location.path('/' + url)

  if Parse.User.current()
    root.user = Parse.User.current()
  else
    root.user = null

app.run ['$rootScope', '$location', rootController]
