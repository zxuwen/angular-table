class configurationVariableNames
  constructor: (@configObjectName) ->
    @itemsPerPage = "#{@configObjectName}.itemsPerPage"
    @sortContext = "#{@configObjectName}.sortContext"
    @fillLastPage = "#{@configObjectName}.fillLastPage"
    @maxPages = "#{@configObjectName}.maxPages"
    @currentPage = "#{@configObjectName}.currentPage"
    @order_by = "#{@configObjectName}.orderBy"

