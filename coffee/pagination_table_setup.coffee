class PaginationTableSetup extends TableSetup

  evaluate_repeat_expression: () ->
    option = {
      "global": "#{@orderByExpression} #{@limitToExpression}",
      "page":   "#{@limitToExpression} #{@orderByExpression}"
    }[@sortContext]

    throw "Invalid sort-context: #{@sortContext}." unless option
    @repeatString = "item in #{@list_name} #{option}"

  constructor: (attributes, table_configuration) ->
    @sortContext    = attributes.atSortContext || "global"
    @list_name      = attributes.atList
    @fillLastPage   = attributes.atFillLastPage
    @evaluate_repeat_expression()

    @table_configuration = table_configuration
    @limit_to_expression = "limitTo:#{irk_from_page} | limitTo:#{@table_configuration.get_items_per_page()}"

    # console.log @limit_to_expression

  compile: (element, attributes, transclude) ->
    tbody = @setupTr(element, @repeatString)

    if typeof @fillLastPage != "undefined"
      tds = element.find("td")
      tdString = ""
      for td in tds
        tdString += "<td>&nbsp;</td>"

      fillerTr = angular.element(document.createElement("tr"))
      fillerTr.html(tdString)
      fillerTr.attr("ng-repeat", "item in getFillerArray() ")

      tbody.append(fillerTr)

    return

  link: ($scope, $element, $attributes, $filter) ->
    list_name = @list_name
    limitToExpression = @limitToExpression

    $scope.filtered_list = () ->
      # console.log $scope.predicate
      val = $filter("orderBy")($scope[list_name], $scope.predicate)

      console.log limitToExpression
      val = $filter("limitTo")(val, limitToExpression)
      console.log val

      return val


    $scope.getFillerArray = () ->
      if $scope[irk_current_page] == $scope[irk_number_of_pages] - 1
        itemCountOnLastPage = $scope[list_name].length % $scope[irk_items_per_page]
        if itemCountOnLastPage != 0 || $scope[list_name].length == 0
          fillerLength = $scope[irk_items_per_page] - itemCountOnLastPage - 1
          x for x in [($scope[list_name].length)..($scope[list_name].length + fillerLength)]
        else
          []

    return
