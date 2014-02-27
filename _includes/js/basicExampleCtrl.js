angular.module("angular-table-example").controller("basicExampleCtrl", ["$scope", function($scope) {
  $scope.list = $scope.$parent.personList
  $scope.config = {
    itemsPerPage: 5,
    fillLastPage: true
  }
}]);