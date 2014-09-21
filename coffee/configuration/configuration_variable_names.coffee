class configuration_variable_names
  constructor: (@configObjectName) ->
    @itemsPerPage = "#{@configObjectName}.itemsPerPage"
    @sortContext = "#{@configObjectName}.sortContext"
    @fillLastPage = "#{@configObjectName}.fillLastPage"
    @maxPages = "#{@configObjectName}.maxPages"
    @currentPage = "#{@configObjectName}.currentPage"
