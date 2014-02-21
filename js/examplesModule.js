angular.module("angular-table-example", ["angular-table", "angular-tabs"]);


angular.module("angular-table-example")
.controller("example-ctrl", ["$scope", "$filter", function($scope, $filter) {

    $scope.personList = [
      {
        index: 1,
        name: "Kristin Hill",
        email: "allen@vaughan.lk"
      },
      {
        index: 2,
        name: "Valerie Francis",
        email: "julia@hardy.ky"
      },
      {
        index: 3,
        name: "Bob Abbott",
        email: "gene@katz.pn"
      },
      {
        index: 4,
        name: "Greg Boyd",
        email: "sherri@lam.fm"
      },
      {
        index: 5,
        name: "Peggy Massey",
        email: "wesley@bowles.um"
      },
      {
        index: 6,
        name: "Janet Bolton",
        email: "donald@eason.br"
      },
      {
        index: 7,
        name: "Maria Liu",
        email: "james@rose.ai"
      },
      {
        index: 8,
        name: "Anne Warren",
        email: "alfred@cowan.es"
      },
      {
        index: 9,
        name: "Keith Steele",
        email: "janet@carey.mk"
      },
      {
        index: 10,
        name: "Jerome Lyons",
        email: "clifford@carey.ax"
      },
      {
        index: 11,
        name: "Jacob Stone",
        email: "joe@bolton.gt"
      },
      {
        index: 12,
        name: "Marion Dunlap",
        email: "wade@creech.np"
      },
      {
        index: 13,
        name: "Stacy Robinson",
        email: "bradley@houston.pl"
      },
      {
        index: 14,
        name: "Luis Chappell",
        email: "joanne@jernigan.tf"
      },
      {
        index: 15,
        name: "Kimberly Horne",
        email: "rita@parsons.au"
      }
    ]

    $scope.config = {
      itemsPerPage: 3,
      maxPages: 3,
      fillLastPage: true
    }
}
]);
