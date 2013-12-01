"use strict"
config = ($routeProvider, $compileProvider) ->

  Parse.initialize("WSGMmizuVjklAI6SpdIMBypeDCzKPUAo05QpWUnV",
                   "OVNmBrjWj4ggScDNvKf159pVQM89vyNTlRIOIh4u")

  $routeProvider.when("/",
    templateUrl: "views/main.html"
    controller: "MainCtrl"

  ).otherwise redirectTo: "/"


app = angular.module("tapwalkdevApp", ['ngRoute'])
app.config config

rootController = (root, location)->

  root.go = (url)->
    location.path('/' + url)

  if Parse.User.current()
    root.user = Parse.User.current()
  else
    root.user = null

app.run ['$rootScope', '$location', rootController]
