angular.module "angular-table", []

angular.module("angular-table").directive "atTable", ["metaCollector", "setupFactory", (metaCollector, setupFactory) ->

  constructHeader = (column_configurations) ->
    tr = angular.element(document.createElement("tr"))

    for i in column_configurations
      tr.append(i.html())

    return tr

  validateInput = (attributes) ->
    if attributes.atPagination and attributes.atList
      throw "You can not specify a list if you have specified a Pagination. The list defined for the pagnination will automatically be used."
    if not attributes.atPagination and not attributes.atList
      throw "Either a list or Pagination must be specified."

  {
    restrict: "AC"
    scope: true
    compile: (element, attributes, transclude) ->
      validateInput attributes

      column_configurations = metaCollector.collectColumnConfigurations(element)

      thead = element.find("thead")
      if thead[0]
        header = constructHeader(column_configurations)
        tr = angular.element(thead).find("tr")
        tr.remove()
        angular.element(thead[0]).append(header)

      setup = setupFactory attributes
      setup.compile(element, attributes, transclude)

      {
        post: ($scope, $element, $attributes) ->
          initialSortingPredicate = undefined
          initialSortingDirection = undefined

          for bd in column_configurations
            if bd.initialSorting
              throw "initial-sorting specified without attribute." if not bd.attribute
            initialSortingPredicate = bd.attribute
            initialSortingDirection = bd.initialSorting

          if initialSortingPredicate
            $scope.predicate = initialSortingPredicate
            $scope.descending = initialSortingDirection == "desc"

          $scope.getSortIcon = (predicate) ->
            return "icon-minus" if predicate != $scope.predicate
            if $scope.descending then "icon-chevron-down" else "icon-chevron-up"

          setup.link($scope, $element, $attributes)

      }
  }
]