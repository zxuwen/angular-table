describe "AnglarTable", () ->

  template1 = "test/templates/sortableTable.html"
  template2 = "test/templates/tableWithPagination.html"

  beforeEach module "angular-table"
  beforeEach module(template1, template2)

  tdsToArray = (tds) ->
    _.map tds, (td) -> angular.element(td).html()

  loadTemplate = (template, templateCache) ->
    angular.element(templateCache.get(template))

  it "makes a table sortable", inject ($compile, $rootScope, $templateCache) ->

    element = loadTemplate template1, $templateCache

    $rootScope.cities = [{name: "Helsinki"}, {name: "Zurich"}, {name: "Amsterdam"}]

    element = $compile(element)($rootScope)
    $rootScope.$digest()

    tds = tdsToArray(element.find("td"))
    expect(tds).toEqual ["Zurich", "Helsinki", "Amsterdam"]

    element.find("th")[0].click()

    tds = tdsToArray(element.find("td"))
    expect(tds).toEqual ["Amsterdam", "Helsinki", "Zurich"]



  it "adds pagination to a table", inject ($compile, $rootScope, $templateCache) ->

    element = loadTemplate template2, $templateCache

    $rootScope.rammstein = [
      {name: "Till"}, {name: "Richard"}, {name: "Christoph"},
      {name: "Paul"}, {name: "Flake"}, {name: "Oliver"}]

    element = $compile(element)($rootScope)
    $rootScope.$digest()

    tds = tdsToArray(element.find("td"))
    expect(tds).toEqual ["Till", "Richard", "Christoph"]

    paginationLinks = element.find "a"
    _.find(paginationLinks, (link) -> angular.element(link).html() == "2").click()

    tds = tdsToArray(element.find("td"))
    expect(tds).toEqual ["Paul", "Flake", "Oliver"]

  it "the pagination automatically updates when elements are added to or removed from the list",
  inject ($compile, $rootScope, $templateCache) ->

    element = loadTemplate template2, $templateCache

    $rootScope.rammstein = [
      {name: "Till"}, {name: "Richard"}, {name: "Christoph"}]

    element = $compile(element)($rootScope)
    $rootScope.$digest()

    tds = tdsToArray(element.find("td"))
    expect(tds).toEqual ["Till", "Richard", "Christoph"]

    paginationLinks = element.find "a"
    # there should be three buttons: << | 1 | >>
    expect(paginationLinks.length).toEqual 3

    $rootScope.rammstein.push {name: "Paul"}
    $rootScope.$digest()
    paginationLinks = element.find "a"
    # now, there should be four buttons: << | 1 | 2 | >>
    expect(paginationLinks.length).toEqual 4
