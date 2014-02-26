class StandardSetup extends Setup
  constructor: (configuration_variable_names) ->
    @repeatString = "item in #{configuration_variable_names.list} | orderBy:predicate:descending"

  compile: (element, attributes, transclude) ->
    @setupTr(element, @repeatString)

  link: () ->
