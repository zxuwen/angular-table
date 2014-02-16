describe "angular-table", () ->
  describe "sorting", () ->

    beforeEach(() ->
      tc = new TemplateCompiler("sorting/sorting.html")
      @element = prepare_element(tc, (scope) ->
        scope.cities = [{name: "Helsinki"}, {name: "Zurich"}, {name: "Amsterdam"}]
      )
    )

    it "allows to set an initial sorting direction", () ->
      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Zurich", "Helsinki", "Amsterdam"]

    it "makes columns sortable", () ->
      click(@element.find("th")[0])
      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Amsterdam", "Helsinki", "Zurich"]