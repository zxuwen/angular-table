class TableSetup

  orderByExpression: "| orderBy:predicate:descending"
  limitToExpression: "| limitTo:#{irk_from_page} | limitTo:#{irk_items_per_page}"

  constructor: () ->

  setupTr: (element, repeatString) ->
    tbody = element.find "tbody"
    tr = tbody.find "tr"
    tr.attr("ng-repeat", repeatString)
    tbody
