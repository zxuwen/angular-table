describe "AnglarTable", () ->

  template2 = "test/templates/tableWithPagination.html"

  beforeEach(module("angular-table"))
  beforeEach(module(template2))

  it "adds pagination to a table", inject ($compile, $rootScope, $templateCache) ->

    element = load_template template2, $templateCache

    $rootScope.rammstein = [
      {name: "Till"}, {name: "Richard"}, {name: "Christoph"},
      {name: "Paul"}, {name: "Flake"}, {name: "Oliver"}]

    element = $compile(element)($rootScope)
    $rootScope.$digest()

    tds = extract_html_to_array(element.find("td"))
    expect(tds).toEqual ["Till", "Richard", "Christoph"]

    paginationLinks = element.find "a"
    _.find(paginationLinks, (link) -> angular.element(link).html() == "2").click()

    tds = extract_html_to_array(element.find("td"))
    expect(tds).toEqual ["Paul", "Flake", "Oliver"]
