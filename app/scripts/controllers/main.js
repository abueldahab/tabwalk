// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  var controller, onError;

  onError = function(error) {
    return console.log(error);
  };

  controller = function(scope, ngTableParams, $filter) {
    var getData, initTable, load, onSuccess, query, userRating;
    userRating = Parse.Object.extend("UserRating");
    query = new Parse.Query(userRating);
    scope.entities = [];
    onSuccess = function(data) {
      scope.entities = data;
      scope.ratingsTable.reload();
      return console.log(scope.entities);
    };
    getData = function() {
      return scope.entities || [];
    };
    initTable = function() {
      return scope.ratingsTable = new ngTableParams({
        page: 1,
        count: 10,
        sorting: {
          datetime: 'desc'
        }
      }, {
        total: function() {
          return getData().length;
        },
        getData: function($defer, params) {
          var data, orderedData;
          data = getData();
          orderedData = (params.filter() ? $filter("filter")(data, params.filter()) : data);
          scope.list = orderedData != null ? orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()) : void 0;
          params.total(orderedData != null ? orderedData.length : void 0);
          return $defer.resolve(scope.list);
        },
        scope: {
          $data: {}
        }
      });
    };
    load = function() {
      return query.find({
        success: onSuccess,
        error: onError
      });
    };
    load();
    return initTable();
  };

  angular.module("tapwalkdevApp").controller("MainCtrl", ['$scope', 'ngTableParams', '$filter', controller]);

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
