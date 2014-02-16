angular.module("angular-table-example").controller("filteredTableCtrl", ["$scope", "$filter", function($scope, $filter) {

  $scope.list = $scope.$parent.personList

  $scope.filteredList = $scope.list

  $scope.queryChanged = function(query) {
    $scope.filteredList = $filter("filter")($scope.list, query);
  };

}])