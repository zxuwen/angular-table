class StandardSetup extends Setup
  constructor: (configuration_variable_names, @list) ->
    @repeatString = "item in #{@list} | orderBy:predicate:descending"

  compile: (element, attributes, transclude) ->
    @setupTr(element, @repeatString)

  link: () ->
