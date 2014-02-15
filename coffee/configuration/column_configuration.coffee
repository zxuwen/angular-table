class ColumnConfiguration

  constructor: (body_markup, header_markup) ->
    @attribute      = body_markup.attribute
    @title          = body_markup.title
    @sortable       = body_markup.sortable
    @width          = body_markup.width
    @initialSorting = body_markup.initialSorting

    if header_markup
      @custom_content    = header_markup.custom_content
      @attributes = header_markup.attributes

  create_element: () ->
    th = angular.element(document.createElement("th"))
    th.attr("style","cursor: pointer;")

  render_title: (element) ->
    element.html(@custom_content || @title)

  render_attributes: (element) ->
    if @custom_content
      for attribute in @attributes
        element.attr(attribute.name, attribute.value)

  render_sorting: (element) ->
    if @sortable
      element.attr("ng-click", "predicate = '#{@attribute}'; descending = !descending;")
      icon = angular.element("<i style='margin-left: 10px;'></i>")
      icon.attr("ng-class", "getSortIcon('#{@attribute}', predicate)")
      element.append(icon)

  render_width: (element) ->
    element.attr("width", @width)

  render_html: () ->
    th = @create_element()
    @render_title(th)
    @render_attributes(th)
    @render_sorting(th)
    @render_width(th)
    return th
