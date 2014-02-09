angular.module "angular-table", []

angular.module("angular-table").directive "atTable", ["metaCollector", "setupFactory", (metaCollector, setupFactory) ->
  {
    restrict: "AC"
    scope: true
    compile: (element, attributes, transclude) ->
      dt = new DeclarativeTable(element, attributes)
      dt.compile(setupFactory)
      {
        post: ($scope, $element, $attributes) ->
          dt.post($scope, $element, $attributes)
      }
  }
]