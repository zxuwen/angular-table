angular.module("angular-table-example").controller("filteredTableCtrl", ["$scope", "$filter", function($scope, $filter) {



  $scope.list = $scope.$parent.personList;

  $scope.filteredList = $scope.list;

  // $scope.getList = function() {
  //   return $filter("filter")($scope.list, $scope.query);
  // }

  $scope.del = function(i) {
    console.log("index: " + i);
    $scope.list.splice(i, 1);
    $scope.updateFilteredList();
  }

  $scope.updateFilteredList = function() {
    $scope.filteredList = $filter("filter")($scope.list, $scope.query);
  };

}])