describe "angular-table", () ->
  describe "pagination", () ->
    beforeEach(() ->
      tc = new TemplateCompiler("pagination.html")
      @element = prepare_element(tc, (scope) ->
        scope.rammstein = [
          {name: "Till"}, {name: "Richard"}, {name: "Christoph"},
          {name: "Paul"}, {name: "Flake"}, {name: "Oliver"}
        ]
      )
    )

    it "adds pagination to a table", inject ($compile, $rootScope, $templateCache) ->
      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Till", "Richard", "Christoph", "Paul"]

      paginationLinks = @element.find "a"
      _.find(paginationLinks, (link) -> angular.element(link).html() == "2").click()

      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Flake", "Oliver", "&nbsp;", "&nbsp;"]
