angular.module "angular-table", []

# internal reserved keywords
# irk_from_page       = "from_page"              # atTable
# irk_current_page    = "current_page"           # atTable (getFillerArray), atPagination
irk_number_of_pages = "number_of_pages"        # atTable (getFillerArray), atPagination

# external reserved keywords
# table
erk_list            = "atList"
erk_items_per_page  = "atItemsPerPage"
erk_fill_last_page  = "atFillLastPage"
erk_sort_context    = "atSortContext"
erk_max_pages       = "atMaxPages"
erk_current_page    = "atCurrentPage"
# column
erk_attribute       = "at-attribute"
erk_sortable        = "at-sortable"
erk_initial_sorting = "at-initial-sorting"

class ScopeConfigWrapper

  constructor: (table_scope, table_configuration) ->
    @scope = table_scope
    @config = table_configuration

  get_list: () ->
    @scope.$eval(@config.list)

  get_items_per_page: () ->
    @scope.$eval(@config.items_per_page)

  get_current_page: () ->
    @scope.$eval(@config.current_page)

  get_max_pages: () ->
    @scope.$eval(@config.max_pages)

  get_sort_context: () ->
    @scope.$eval(@config.sort_context)

class AngularTableManager

  constructor: () ->
    @mappings = {}

  get_table_configuration: (id) ->
    @mappings[id].table_configuration

  register_table: (table_configuration) ->
    mapping = @mappings[table_configuration.id] ||= {}

    mapping.table_configuration = table_configuration

    if mapping.pagination_scope
      throw "WHOOPS"

  register_table_scope: (id, scope, filter) ->
    @mappings[id].table_scope = scope

    tc = @mappings[id].table_configuration

    if tc.initial_items_per_page
      scope.$parent[tc.items_per_page] = tc.initial_items_per_page

    if tc.initial_sort_context
      scope.$parent[tc.sort_context] = tc.initial_sort_context

    if tc.initial_fill_last_page
      scope.$parent[tc.fill_last_page] = tc.initial_fill_last_page

    if tc.initial_max_pages
      scope.$parent[tc.max_pages] = tc.initial_max_pages

    if tc.initial_current_page isnt undefined
      scope.$parent[tc.current_page] = tc.initial_current_page

angular.module("angular-table").service "angularTableManager", [() ->
  new AngularTableManager()
]

angular.module("angular-table").directive "atTable", ["$filter", "angularTableManager", ($filter, angularTableManager) ->
  {
    restrict: "AC"
    scope: true
    controller: ["$scope", "$element", "$attrs",
    ($scope, $element, $attrs) ->
      id = $attrs["id"]
      if id
        angularTableManager.register_table_scope(id, $scope, $filter)
    ]

    compile: (element, attributes, transclude) ->
      tc = new TableConfiguration(element, attributes)
      angularTableManager.register_table(tc)

      dt = new Table(element, tc)
      dt.compile()
      {
        post: ($scope, $element, $attributes) ->
          dt.post($scope, $element, $attributes, $filter)
      }
  }
]
