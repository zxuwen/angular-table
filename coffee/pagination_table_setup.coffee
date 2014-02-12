class PaginationTableSetup extends TableSetup

  constructor: (table_configuration) ->
    @table_configuration = table_configuration
    @repeatString = "item in filtered_list()"

  compile: (element) ->
    tbody = @setupTr(element, @repeatString)

    tds = element.find("td")
    tdString = ""
    for td in tds
      tdString += "<td>&nbsp;</td>"

    # TODO
    fillerTr = angular.element(document.createElement("tr"))
    fillerTr.attr("ng-show", @table_configuration.fill_last_page)
    fillerTr.html(tdString)
    fillerTr.attr("ng-repeat", "item in getFillerArray() ")

    tbody.append(fillerTr)

    return

  link: ($scope, $element, $attributes, $filter) ->
    list_name = @table_configuration.list
    ipp = @table_configuration.items_per_page
    sc = @table_configuration.sort_context

    $scope.filtered_list = () ->
      val = $scope[list_name]

      if $scope[sc] == "global"
        val = $filter("orderBy")(val, $scope.predicate, $scope.descending)
        val = $filter("limitTo")(val, $scope[irk_from_page])
        val = $filter("limitTo")(val, $scope[ipp])
      else
        val = $filter("limitTo")(val, $scope[irk_from_page])
        val = $filter("limitTo")(val, $scope[ipp])
        val = $filter("orderBy")(val, $scope.predicate, $scope.descending)

      return val

    $scope.getFillerArray = () ->
      if $scope[irk_current_page] == $scope[irk_number_of_pages] - 1
        itemCountOnLastPage = $scope[list_name].length % $scope[ipp]
        if itemCountOnLastPage != 0 || $scope[list_name].length == 0
          fillerLength = $scope[ipp] - itemCountOnLastPage - 1
          x for x in [($scope[list_name].length)..($scope[list_name].length + fillerLength)]
        else
          []