angular.module("angular-table").directive "atTable", ["$filter", "angularTableManager", ($filter, angularTableManager) ->
  {
    restrict: "AC"
    scope: true
    controller: ["$scope", "$element", "$attrs",
    ($scope, $element, $attrs) ->
      id = $attrs["id"]
      if id
        angularTableManager.register_table_scope(id, $scope, $filter)
    ]

    compile: (element, attributes, transclude) ->
      tc = new TableConfiguration(element, attributes)
      angularTableManager.register_table(tc)

      dt = new Table(element, tc)
      dt.compile()
      {
        post: ($scope, $element, $attributes) ->
          dt.post($scope, $element, $attributes, $filter)
      }
  }
]
