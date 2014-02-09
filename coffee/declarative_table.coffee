class DeclarativeTable extends Table

  constructor: (@element, @attributes) ->

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
    header_markup = @collect_header_markup(@element)
    body_markup = @collect_body_markup(@element)

    column_configurations = []

    for i in body_markup
      column_configurations.push new ColumnConfiguration(i, header_markup[i.attribute])

    return column_configurations

  get_column_configurations: () ->
    @column_configurations ||= @create_column_configurations()
