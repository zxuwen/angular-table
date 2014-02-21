angular.module("angular-table-example").controller("interactiveExampleCtrl", ["$scope", "$filter", function($scope, $filter) {
  $scope.originalList = $scope.$parent.personList;

  $scope.filteredList = $scope.originalList;

  $scope.config = {
    itemsPerPage: 5,
    maxPages: 5,
    fillLastPage: "yes"
  };

  $scope.add = function() {
    $scope.originalList.push({name: $scope.nameToAdd});
    $scope.updateFilteredList();
  }

  $scope.updateFilteredList = function() {
    $scope.filteredList = $filter("filter")($scope.originalList, $scope.query);
  };
}])