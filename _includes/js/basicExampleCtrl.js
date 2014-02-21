angular.module("angular-table-example").controller("basicExampleCtrl", ["$scope", function($scope) {
  $scope.list = $scope.$parent.personList
}])