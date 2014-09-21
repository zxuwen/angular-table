class ScopeConfigWrapper
  constructor: (@scope, @configuration_variable_names, @list_name) ->

  getList: () ->
    @scope.$eval(@list_name)

  getItemsPerPage: () ->
    @scope.$eval(@configuration_variable_names.itemsPerPage) || 10

  getCurrentPage: () ->
    @scope.$eval(@configuration_variable_names.currentPage) || 0

  getMaxPages: () ->
    @scope.$eval(@configuration_variable_names.maxPages) || undefined

  getSortContext: () ->
    @scope.$eval(@configuration_variable_names.sortContext) || 'global'

  setCurrentPage: (currentPage) ->
    @scope.$eval("#{@configuration_variable_names.currentPage}=#{currentPage}")
