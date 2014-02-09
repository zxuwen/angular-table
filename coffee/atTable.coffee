angular.module "angular-table", []

angular.module("angular-table").directive "atTable", [() ->
  {
    restrict: "AC"
    scope: true
    compile: (element, attributes, transclude) ->
      dt = new DeclarativeTable(element, attributes)
      dt.compile()
      {
        post: ($scope, $element, $attributes) ->
          dt.post($scope, $element, $attributes)
      }
  }
]