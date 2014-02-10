class TableConfiguration

  register_items_per_page: (items_per_page) ->
    n = parseInt(items_per_page)
    if angular.isNumber(n)
      @items_per_page = "#{@id}_itemsPerPage"
      # @scope.$parent[@items_per_page] = n
    else
      @items_per_page = items_per_page

  constructor: (attributes) ->
    # console.log $scope
    # @scope = $scope
    @id              = attributes.id
    @list            = attributes[erk_list]
    @fill_last_page  = attributes[erk_fill_last_page]

    @register_items_per_page(attributes[erk_items_per_page]) if attributes[erk_items_per_page]

    @sort_context    = attributes[erk_sort_context]

  # get_scope: () ->
  #   @scope

  get_id: () ->
    @id

  get_list: () ->
    @list

  get_fill_last_page: () ->
    @fill_last_page

  get_items_per_page: () ->
    @items_per_page

  get_sort_context: () ->
    @sort_context

new TableConfiguration({}, {})