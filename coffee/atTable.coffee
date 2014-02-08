angular.module "angular-table", []

angular.module("angular-table").directive "atTable", ["metaCollector", "setupFactory", (metaCollector, setupFactory) ->

  # TODO clean up
  constructHeader = (customHeaderMarkup, bodyDefinitions) ->
    tr = angular.element("<table><tr></tr></table>")
    tr = tr.find("tr")

    for td in bodyDefinitions
      th = angular.element("<table><th style='cursor: pointer;'></th></table>")
      th = th.find("th")
      if customHeaderMarkup[td.attribute]
        for attribute in customHeaderMarkup[td.attribute].attributes
          th.attr("#{attribute.name}", "#{attribute.value}")
        title = customHeaderMarkup[td.attribute].content
      else
        title = td.title

      th.html("#{title}")

      if td.sortable
        th.attr("ng-click", "predicate = '#{td.attribute}'; descending = !descending;")
        icon = angular.element("<i style='margin-left: 10px;'></i>")
        icon.attr("ng-class", "getSortIcon('#{td.attribute}')")
        th.append(icon)

      th.attr("width", td.width)
      tr.append(th)

    tr


  validateInput = (attributes) ->
    if attributes.pagination and attributes.atList
      throw "You can not specify a list if you have specified a pagination. The list defined for the pagnination will automatically be used."
    if not attributes.pagination and not attributes.atList
      throw "Either a list or pagination must be specified."

  normalizeInput = (attributes) ->
    if attributes.atPagination
      attributes.pagination = attributes.atPagination
      attributes.atPagination = null

  {
    restrict: "AC"
    scope: true
    compile: (element, attributes, transclude) ->
      normalizeInput attributes
      validateInput attributes


      bodyDefinition = metaCollector.collectBodyDefinition(element)

      # TODO: better solution
      thead = element.find("thead")
      if thead[0]
        customHeaderMarkup = metaCollector.collectCustomHeaderMarkup(element)
        tr = angular.element(thead).find("tr")
        tr.remove()
        header = constructHeader(customHeaderMarkup, bodyDefinition.tds)
        angular.element(thead[0]).append(header)

      setup = setupFactory attributes
      setup.compile(element, attributes, transclude)

      {
        post: ($scope, $element, $attributes) ->

          if bodyDefinition.initialSorting
            $scope.predicate = bodyDefinition.initialSorting.predicate
            $scope.descending = (bodyDefinition.initialSorting.direction == "desc")

          $scope.getSortIcon = (predicate) ->
            return "icon-minus" if predicate != $scope.predicate
            if $scope.descending then "icon-chevron-down" else "icon-chevron-up"

          setup.link($scope, $element, $attributes)
      }
  }
]