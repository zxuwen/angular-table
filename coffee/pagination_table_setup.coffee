class PaginationTableSetup extends TableSetup
  constructor: (attributes) ->
    @sortContext = attributes.atSortContext || "global"
    @paginationName = attributes.atPagination
    @fillLastPage = attributes.atFillLastPage

    if @sortContext == "global"
      @repeatString = "item in #{@paginationName}.atList #{@orderByExpression} #{@limitToExpression}"
    else if @sortContext == "page"
      @repeatString = "item in #{@paginationName}.atList #{@limitToExpression} #{@orderByExpression} "
    else
      throw "Invalid sort-context: #{@sortContext}."

  compile: (element, attributes, transclude) ->
    tbody = @setupTr(element, @repeatString)

    if typeof @fillLastPage != "undefined"
      tds = element.find("td")
      tdString = ""
      for td in tds
        tdString += "<td>&nbsp;</td>"

      fillerTr = angular.element(document.createElement("tr"))
      fillerTr.html(tdString)
      fillerTr.attr("ng-repeat", "item in #{@paginationName}.getFillerArray() ")

      tbody.append(fillerTr)

    return

  link: ($scope, $element, $attributes) ->
    paginationName = @paginationName

    $scope.fromPage = () ->
      if $scope[paginationName] then $scope[paginationName].fromPage()

    $scope.toPage = () ->
      if $scope[paginationName] then $scope[paginationName].atItemsPerPage

    return
