angular.module("angular-table").directive "atTable", ["$filter", "angularTableManager", ($filter, angularTableManager) ->
  {
    restrict: "AC"
    scope: true

    compile: (element, attributes, transclude) ->
      tc = new TableConfiguration(element, attributes)
      cvn = new ConfigurationVariableNames(attributes.atConfig)
      dt = new Table(element, tc, cvn)
      dt.compile()
      {
        post: ($scope, $element, $attributes) ->
          dt.post($scope, $element, $attributes, $filter)
      }
  }
]
