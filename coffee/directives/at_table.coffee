angular.module("angular-table").directive "atTable", ["$filter", "angularTableManager", ($filter, angularTableManager) -> {
  restrict: "AC"
  scope: true

  compile: (element, attributes, transclude) ->
    tc = new TableConfiguration(element, attributes)
    cvn = new ConfigurationVariableNames(attributes.atConfig)
    table = new Table(element, tc, cvn)
    table.compile()

    post: ($scope, $element, $attributes) ->
      table.post($scope, $element, $attributes, $filter)

}]
