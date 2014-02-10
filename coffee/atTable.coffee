angular.module "angular-table", []

# internal reserved keywords
irk_from_page       = "from_page"              # atTable
irk_current_page    = "current_page"           # atTable (getFillerArray), atPagination
irk_number_of_pages = "number_of_pages"        # atTable (getFillerArray), atPagination
irk_items_per_page  = "items_per_page"         # atTable, atPagination (calculate number of pages)
irk_list            = "list"                   # atTable, atPagination

# external reserved keywords
# table
erk_list            = "atList"
erk_items_per_page  = "atItemsPerPage"
erk_fill_last_page  = "atFillLastPage"
erk_sort_context    = "atSortContext"
# column
erk_attribute       = "at-attribute"
erk_sortable        = "at-sortable"
erk_initial_sorting = "at-initial-sorting"

calculate_from_page = (items_per_page, current_page, list) ->
  if list
    items_per_page * current_page - list.length

class AngularTableManager

  constructor: () ->
    @mappings = {}

  register_table: (table_configuration) ->
    mapping = @mappings[table_configuration.get_id()] ||= {}

    mapping.table_configuration = table_configuration

    if mapping.pagination_scope
      throw "WHOOPS"

  register_table_scope: (id, scope) ->
    @mappings[id].table_scope = scope

  register_pagination: (id, pagination_scope) ->
    mapping = @mappings[id] ||= {}
    mapping.pagination_scope = pagination_scope

    if mapping.table_configuration
      pagination_scope[irk_list] = mapping.table_configuration.get_list()

      pagination_scope.$watch(irk_current_page, () ->
        ts = mapping.table_scope
        ts[irk_current_page]    = pagination_scope[irk_current_page]
        ts[irk_items_per_page]  = pagination_scope[irk_items_per_page]
        ts[irk_number_of_pages] = pagination_scope[irk_number_of_pages]
        ts[irk_from_page]       = calculate_from_page(ts[irk_items_per_page],
                                                      ts[irk_current_page],
                                                      ts[mapping.table_configuration.get_list()])
      )

angular.module("angular-table").service "angularTableManager", [() ->
  new AngularTableManager()
]

angular.module("angular-table").directive "atTable", ["$filter", "angularTableManager", ($filter, angularTableManager) ->
  {
    restrict: "AC"
    scope: true
    controller: ["$scope", "$element", "$attrs", "angularTableManager",
    ($scope, $element, $attrs, angularTableManager) ->
      id = $attrs["id"]
      if id
        angularTableManager.register_table_scope(id, $scope)
    ]

    compile: (element, attributes, transclude) ->
      tc = new TableConfiguration(attributes)
      angularTableManager.register_table(tc)

      dt = new DeclarativeTable(element, attributes, tc)
      dt.compile()
      {
        post: ($scope, $element, $attributes) ->
          dt.post($scope, $element, $attributes, $filter)
      }
  }
]

# <table at-list="myList" at-items-per-page="itemsPerPage">

# itemsPerPage ist im parent scope definiert
#   table und pagination können diese variable watchen und müssen ihre eigen scopevariablen updaten
#   das selbe gilt für fill-last-page und sort-context

# <table at-list="myList" at-items-per-page="4">
# es muss eine itemsPerPage variable im parent scope erstellt werden



# current_page kann sich ändern in der pagination
# dann muss table notifiziert werden

