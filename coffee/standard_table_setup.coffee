class StandardTableSetup extends TableSetup
  constructor: (attributes) ->
    @repeatString = "item in #{attributes.atList} #{@orderByExpression}"

  compile: (element, attributes, transclude) ->
    @setupTr(element, @repeatString)

  link: () ->
