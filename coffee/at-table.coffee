angular.module "angular-table", []

# internal reserved keywords
irk_from_page       = "from_page"              # atTable
irk_current_page    = "current_page"           # atTable (getFillerArray), atPagination
irk_number_of_pages = "number_of_pages"        # atTable (getFillerArray), atPagination

# external reserved keywords
# table
erk_list            = "atList"
erk_items_per_page  = "atItemsPerPage"
erk_fill_last_page  = "atFillLastPage"
erk_sort_context    = "atSortContext"
erk_max_pages       = "atMaxPages"
# column
erk_attribute       = "at-attribute"
erk_sortable        = "at-sortable"
erk_initial_sorting = "at-initial-sorting"

calculate_from_page = (items_per_page, current_page, list) ->
  if list
    items_per_page * current_page - list.length

update_table_scope = (table_scope, pagination_scope, table_configuration) ->
  table_scope[irk_current_page]    = pagination_scope[irk_current_page]
  table_scope[irk_number_of_pages] = pagination_scope[irk_number_of_pages]
  table_scope[irk_from_page]       = calculate_from_page(table_scope[table_configuration.items_per_page],
                                                         table_scope[irk_current_page],
                                                         table_scope[table_configuration.list])

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

  register_table_scope: (id, scope) ->
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


  register_pagination_scope: (id, pagination_scope) ->
    mapping = @mappings[id] ||= {}
    mapping.pagination_scope = pagination_scope

    if mapping.table_configuration
      pagination_scope.$watch(irk_current_page, () ->
        update_table_scope(mapping.table_scope, pagination_scope, mapping.table_configuration)
      )

      pagination_scope.$watch(irk_number_of_pages, () ->
        update_table_scope(mapping.table_scope, pagination_scope, mapping.table_configuration)
      )

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
        angularTableManager.register_table_scope(id, $scope)
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
