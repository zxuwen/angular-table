class ColumnConfiguration
  constructor: (body_markup, header_markup) ->
    @attribute      = body_markup.attribute
    @title          = body_markup.title
    @sortable       = body_markup.sortable
    @width          = body_markup.width
    @initialSorting = body_markup.initialSorting

    if header_markup
      @content    = header_markup.content
      @attributes = header_markup.attributes

  html: () ->
    th = angular.element(document.createElement("th"))
    th.attr("style","cursor: pointer;")

    if @content
      for attribute in @attributes
        th.attr(attribute.name, attribute.value)
      title = @content
    else
      title = @title

    th.html(title)

    if @sortable
      th.attr("ng-click", "predicate = '#{@attribute}'; descending = !descending;")
      icon = angular.element("<i style='margin-left: 10px;'></i>")
      icon.attr("ng-class", "getSortIcon('#{@attribute}')")
      th.append(icon)

    th.attr("width", @width)

    return th

angular.module("angular-table").service "metaCollector", [() ->

  capitaliseFirstLetter = (string) ->
    if string then string.charAt(0).toUpperCase() + string.slice(1) else ""

  extractWidth = (classes) ->
    width = /([0-9]+px)/i.exec classes
    if width then width[0] else ""

  isSortable = (classes) ->
    sortable = /(sortable)/i.exec classes
    if sortable then true else false

  getInitialSorting = (td) ->
    initialSorting = td.attr("at-initial-sorting")
    if initialSorting
      return initialSorting if initialSorting == "asc" || initialSorting == "desc"
      throw "Invalid value for initial-sorting: #{initialSorting}. Allowed values are 'asc' or 'desc'."
    return undefined

  collect_header_markup = (table) ->
    customHeaderMarkups = {}

    tr = table.find("tr")
    for th in tr.find("th")
      th = angular.element(th)
      customHeaderMarkups[th.attr("at-attribute")] = {
        content: th.html(), attributes: th[0].attributes
      }

    return customHeaderMarkups

  collect_body_markup = (table) ->
    bodyDefinition = []

    for td in table.find("td")
      td = angular.element(td)

      attribute = td.attr("at-attribute")
      title = td.attr("at-title") || capitaliseFirstLetter(td.attr("at-attribute"))
      sortable = td.attr("at-sortable") != undefined || isSortable(td.attr("class"))
      width = extractWidth(td.attr("class"))
      initialSorting = getInitialSorting td

      bodyDefinition.push {
        attribute: attribute, title: title, sortable: sortable,
        width: width, initialSorting: initialSorting
      }

    return bodyDefinition

  {

    collectColumnConfigurations: (table) ->
      header_markup = collect_header_markup(table)
      body_markup = collect_body_markup(table)

      column_configuration = []

      for i in body_markup
        column_configuration.push new ColumnConfiguration(i, header_markup[i.attribute])

      return column_configuration
  }
]