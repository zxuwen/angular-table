angular.module("angular-table").service "metaCollector", [() ->

  capitaliseFirstLetter = (string) ->
    if string then string.charAt(0).toUpperCase() + string.slice(1) else ""

  extractWidth = (classes) ->
    width = /([0-9]+px)/i.exec classes
    if width then width[0] else ""

  isSortable = (classes) ->
    sortable = /(sortable)/i.exec classes
    if sortable then true else false

  getInitialSortDirection = (td) ->
    initialSorting = td.attr("at-initial-sorting")
    if initialSorting
      return initialSorting if initialSorting == "asc" || initialSorting == "desc"
      throw "Invalid value for initial-sorting: #{initialSorting}. Allowed values are 'asc' or 'desc'."
    return undefined

  # collectAttributes = (attributes) ->
  #   result = []
  #   for attribute in attributes
  #     result.push({name: attribute.name, value: attribute.value})

  {
    collectCustomHeaderMarkup: (thead) ->
      customHeaderMarkups = {}

      tr = thead.find "tr"
      for th in tr.find "th"
        th = angular.element(th)
        customHeaderMarkup = customHeaderMarkups[th.attr("at-attribute")] = {}
        customHeaderMarkup.content = th.html()
        customHeaderMarkup.attributes = th[0].attributes

      customHeaderMarkups

    collectBodyDefinition: (tbody) ->
      bodyDefinition = {}
      bodyDefinition.tds = []
      bodyDefinition.initialSorting = undefined

      for td in tbody.find("td")
        td = angular.element(td)

        attribute = td.attr("at-attribute")
        title = td.attr("at-title") || capitaliseFirstLetter(td.attr("at-attribute"))
        sortable = td.attr("at-sortable") != undefined || isSortable(td.attr("class"))
        width = extractWidth(td.attr("class"))

        bodyDefinition.tds.push {attribute: attribute, title: title, sortable: sortable, width: width}

        initialSortDirection = getInitialSortDirection td
        if initialSortDirection
          throw "initial-sorting specified without attribute." if not attribute
          bodyDefinition.initialSorting = {}
          bodyDefinition.initialSorting.direction = initialSortDirection
          bodyDefinition.initialSorting.predicate = attribute


      bodyDefinition

  }
]