class Table
  constructHeader: () ->
    tr = angular.element(document.createElement("tr"))
    for i in @get_column_configurations()
      tr.append(i.render_html())
    return tr

  setup_header: () ->
    thead = @element.find("thead")
    if thead
      header = @constructHeader()
      tr = angular.element(thead).find("tr")
      tr.remove()
      thead.append(header)

  validateInput: () ->
    # if @attributes.atPagination and @attributes.atList
      # throw "You can not specify a list if you have specified a Pagination. The list defined for the pagnination will automatically be used."
    if not @attributes.atPagination and not @attributes.atList
      throw "Either a list or Pagination must be specified."

  create_table_setup: (attributes) ->
    if attributes.atList && !attributes.atPagination
      return new StandardTableSetup(attributes)
    if attributes.atList && attributes.atPagination
      return new PaginationTableSetup(attributes, @table_configuration)
    return

  compile: () ->
    @validateInput()
    @setup_header()
    @setup = @create_table_setup(@attributes)
    @setup.compile(@element, @attributes)

  setup_initial_sorting: ($scope) ->
    for bd in @get_column_configurations()
      if bd.initialSorting
        throw "initial-sorting specified without attribute." if not bd.attribute
      $scope.predicate = bd.attribute
      $scope.descending = bd.initialSorting == "desc"

  post: ($scope, $element, $attributes, $filter) ->
    @setup_initial_sorting($scope)

    $scope.getSortIcon = (predicate) ->
      return "icon-minus" if predicate != $scope.predicate
      if $scope.descending then "icon-chevron-down" else "icon-chevron-up"

    @setup.link($scope, $element, $attributes, $filter)
