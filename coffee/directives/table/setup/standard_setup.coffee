class StandardSetup extends Setup

  constructor: (table_configuration) ->
    @repeatString = "item in #{table_configuration.list} | orderBy:predicate:descending"

  compile: (element, attributes, transclude) ->
    @setupTr(element, @repeatString)

  link: () ->
