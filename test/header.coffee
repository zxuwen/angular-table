describe "angular-table", () ->
  describe "header", () ->

    it "doesnt add a header at all if the header tag wasnt declared", () ->
      @element = prepare_element(new TemplateCompiler("header/no_header.html"), (scope) ->)
      header = @element.find("thead")[0]
      expect(header).toBe undefined

    it "creates column headers implicitly", () ->
      @element = prepare_element(new TemplateCompiler("header/header.html"), (scope) ->)
      header = extract_html_to_array(@element.find("thead > tr > th"))
      expect(header[0]).toEqual 'Name'

    it "allows to set custom column headers", () ->
      @element = prepare_element(new TemplateCompiler("header/header.html"), (scope) ->)
      header = extract_html_to_array(@element.find("thead > tr > th"))
      expect(header[1]).toEqual 'The population'
      expect(header[2]).toEqual 'Country'
      expect(header[3]).toEqual 'Size'
