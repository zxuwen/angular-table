class TableConfiguration

  constructor: (@table_element, @attributes) ->
    @id              = @attributes.id
    @list            = @attributes[erk_list]
    @register_items_per_page(@attributes[erk_items_per_page]) if @attributes[erk_items_per_page]
    @register_sort_context(@attributes[erk_sort_context])
    @register_fill_last_page(@attributes[erk_fill_last_page])
    @register_max_pages(@attributes[erk_max_pages])
    @paginated       = @items_per_page != undefined
    @create_column_configurations()

  # TODO: refactor the following 4 methods into nicer, if-less logic
  register_items_per_page: (items_per_page) ->
    if isNaN(items_per_page)
      @items_per_page = items_per_page
    else
      @items_per_page = "#{@id}_itemsPerPage"
      @initial_items_per_page = parseInt(items_per_page)

  register_sort_context: (sort_context) ->
    if sort_context != undefined
      if sort_context == "global"
        @sort_context = "#{@id}_sortContext"
        @initial_sort_context = "global"
      else if sort_context == "page"
        @sort_context = "#{@id}_sortContext"
        @initial_sort_context = "page"
      else
        @sort_context = sort_context
    else
      @sort_context = "#{@id}_sortContext"
      @initial_sort_context = "global"

  register_fill_last_page: (fill_last_page) ->
    if fill_last_page != undefined
      if fill_last_page == "true"
        @fill_last_page = "#{@id}_fillLastPage"
        @initial_fill_last_page = true
      else if fill_last_page == "false"
        @fill_last_page = "#{@id}_fillLastPage"
        @initial_fill_last_page = false
      else if fill_last_page == ""
        @fill_last_page = "#{@id}_fillLastPage"
        @initial_fill_last_page = true
      else
        @fill_last_page = fill_last_page

  register_max_pages: (max_pages) ->
    if max_pages isnt undefined
      if isNaN(max_pages)
        @max_pages = max_pages
      else
        @max_pages = "#{@id}_maxPages"
        @initial_max_pages = parseInt(max_pages)

  capitaliseFirstLetter: (string) ->
    if string then string.charAt(0).toUpperCase() + string.slice(1) else ""

  extractWidth: (classes) ->
    width = /([0-9]+px)/i.exec classes
    if width then width[0] else ""

  isSortable: (classes) ->
    sortable = /(sortable)/i.exec classes
    if sortable then true else false

  getInitialSorting: (td) ->
    initialSorting = td.attr("at-initial-sorting")
    if initialSorting
      return initialSorting if initialSorting == "asc" || initialSorting == "desc"
      throw "Invalid value for initial-sorting: #{initialSorting}. Allowed values are 'asc' or 'desc'."
    return undefined

  collect_header_markup: (table) ->
    customHeaderMarkups = {}

    tr = table.find("tr")
    for th in tr.find("th")
      th = angular.element(th)
      customHeaderMarkups[th.attr("at-attribute")] = {
        custom_content: th.html(), attributes: th[0].attributes
      }

    return customHeaderMarkups

  collect_body_markup: (table) ->
    bodyDefinition = []

    for td in table.find("td")
      td = angular.element(td)

      attribute = td.attr("at-attribute")
      title = td.attr("at-title") || @capitaliseFirstLetter(td.attr("at-attribute"))
      sortable = td.attr("at-sortable") != undefined || @isSortable(td.attr("class"))
      width = @extractWidth(td.attr("class"))
      initialSorting = @getInitialSorting(td)

      bodyDefinition.push {
        attribute: attribute, title: title, sortable: sortable,
        width: width, initialSorting: initialSorting
      }

    return bodyDefinition

  create_column_configurations: () ->
    header_markup = @collect_header_markup(@table_element)
    body_markup = @collect_body_markup(@table_element)

    @column_configurations = []

    for i in body_markup
      @column_configurations.push new ColumnConfiguration(i, header_markup[i.attribute])

    return @column_configurations
