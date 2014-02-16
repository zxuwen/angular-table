describe "angular-table", () ->
  describe "pagination", () ->
    it "adds pagination to a table", () ->
      @element = prepare_element(new TemplateCompiler("pagination/pagination.html"), (scope) ->
        scope.rammstein = [
          {name: "Till"}, {name: "Richard"}, {name: "Christoph"},
          {name: "Paul"}, {name: "Flake"}, {name: "Oliver"}
        ]
      )

      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Till", "Richard", "Christoph", "Paul"]

      paginationLinks = @element.find "a"
      link = _.find(paginationLinks, (link) -> angular.element(link).html() == "2")
      click(link)

      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Flake", "Oliver", "&nbsp;", "&nbsp;"]

    describe "sort context", () ->
      callback = (scope) ->
        scope.letters = [{char: "c"}, {char: "b"}, {char: "d"}, {char: "f"},
                         {char: "a"}, {char: "e"}, {char: "h"}, {char: "g"}]

      it "allows to set the sort context to global", () ->
        @element = prepare_element(new TemplateCompiler("pagination/sort_context_global.html"), callback)
        tds = extract_html_to_array(@element.find("td"))
        expect(tds).toEqual ["a", "b", "c", "d"]

      it "allows to set the sort context to page", () ->
        @element = prepare_element(new TemplateCompiler("pagination/sort_context_page.html"), callback)
        tds = extract_html_to_array(@element.find("td"))
        expect(tds).toEqual ["b", "c", "d", "f"]