class TableSetup
  orderByExpression: "| orderBy:predicate:descending"
  limitToExpression: "| limitTo:fromPage() | limitTo:toPage()"

  constructor: () ->

  setupTr: (element, repeatString) ->
    tbody = element.find "tbody"
    tr = tbody.find "tr"
    tr.attr("ng-repeat", repeatString)
    tbody

  (attributes) ->
    if attributes.atList
      return new StandardSetup(attributes)
    if attributes.atPagination
      return new PaginationSetup(attributes)
    return
