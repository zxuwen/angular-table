angular.module("angular-table").factory "setupFactory", [() ->

  orderByExpression = "| orderBy:predicate:descending"
  limitToExpression = "| limitTo:fromPage() | limitTo:toPage()"

  setupTr = (element, repeatString) ->
    tbody = element.find "tbody"
    tr = tbody.find "tr"
    tr.attr("ng-repeat", repeatString)
    tbody

  StandardSetup = (attributes) ->
    repeatString = "item in #{attributes.atList} #{orderByExpression}"
    @compile = (element, attributes, transclude) ->
      setupTr element, repeatString

    @link = () ->
    return

  PaginationSetup = (attributes) ->
    sortContext = attributes.atSortContext || "global"

    paginationName = attributes.pagination

    if sortContext == "global"
      repeatString = "item in #{paginationName}.atList #{orderByExpression} #{limitToExpression}"
    else if sortContext == "page"
      repeatString = "item in #{paginationName}.atList #{limitToExpression} #{orderByExpression} "
    else
      throw "Invalid sort-context: #{sortContext}."

    @compile = (element, attributes, transclude) ->
      tbody = setupTr element, repeatString

      if typeof attributes.atFillLastPage != "undefined"
        tds = element.find("td")
        tdString = ""
        for td in tds
          tdString += "<td>&nbsp;</td>"

        fillerTr = angular.element(document.createElement("tr"))
        fillerTr.html(tdString)
        fillerTr.attr("ng-repeat", "item in #{paginationName}.getFillerArray() ")

        tbody.append(fillerTr)

    @link = ($scope, $element, $attributes) ->
      $scope.fromPage = () ->
        if $scope[paginationName] then $scope[paginationName].fromPage()

      $scope.toPage = () ->
        if $scope[paginationName] then $scope[paginationName].atItemsPerPage

    return

  (attributes) ->
    if attributes.atList
      return new StandardSetup(attributes)
    if attributes.pagination
      return new PaginationSetup(attributes)
    return

]