class TableConfiguration

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

  constructor: (attributes) ->
    @id              = attributes.id
    @list            = attributes[erk_list]
    @register_items_per_page(attributes[erk_items_per_page]) if attributes[erk_items_per_page]
    @register_sort_context(attributes[erk_sort_context])
    @register_fill_last_page(attributes[erk_fill_last_page])
