describe "angular-table", () ->
  describe "header", () ->

    it "doesnt add a header at all if the header tag isnt declared", () ->
      comp = new TemplateCompiler("header/no_header.html")
      @element = comp.prepare_element((scope) ->)
      header = @element.find("thead")[0]
      expect(header).toBe undefined

    it "creates column headers implicitly", () ->
      comp = new TemplateCompiler("header/header.html")
      @element = comp.prepare_element((scope) ->)
      header = extract_html_to_array(getChildrenFor(@element, "thead > tr > th"))
      expect(header[0]).toEqual "Name"

    it "allows to set custom column headers", () ->
      comp = new TemplateCompiler("header/header.html")
      @element = comp.prepare_element((scope) ->)
      header = extract_html_to_array(getChildrenFor(@element, "thead > tr > th"))
      expect(header[1]).toEqual "The population"
      expect(header[2]).toEqual "Country"
      expect(header[3]).toEqual "<b>Size</b>"
