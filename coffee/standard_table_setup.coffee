class StandardTableSetup extends TableSetup
  constructor: (attributes) ->
    @repeatString = "item in #{attributes.atList} | orderBy:predicate:descending"

  compile: (element, attributes, transclude) ->
    @setupTr(element, @repeatString)

  link: () ->
