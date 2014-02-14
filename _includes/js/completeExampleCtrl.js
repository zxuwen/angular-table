angular.module("angular-table-example").controller("completeExampleCtrl", ["$scope", function($scope) {
  $scope.list = $scope.$parent.personList
}])