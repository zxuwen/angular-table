angular.module("angular-table-example").controller("walkthroughCtrl", ["$scope", function($scope) {
  $scope.people = [];

  for (var i = 0; i < 100; i++) {
    $scope.people.push({
      id: i,
      name: "Kristin Hill",
      age: 25,
      birthdate: "date"
    })
  }
}]);