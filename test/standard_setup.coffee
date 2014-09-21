describe "angular-table", () ->
  describe "standard setup", () ->

    expected_rows = [
      ["0", "Helsinki",  "Finland"],
      ["1", "Zurich",    "Switzerland"],
      ["2", "Amsterdam", "Netherlands"],
      ["3", "Berlin",    "Germany"]
    ]

    beforeEach(() ->
      comp = new TemplateCompiler("standard_setup.html")
      @element = comp.prepare_element((scope) ->
        scope.cities = [{
          id: 0
          name: "Helsinki"
          country: "Finland"
        }, {
          id: 1
          name: "Zurich"
          country: "Switzerland"
        }, {
          id: 2
          name: "Amsterdam"
          country: "Netherlands"
        }]
      )

      @gui = new GUI(new TableGUI(@element), null, comp.scope, null)
    )

    it "allows to set an initial sorting direction", () ->
      expect(@gui.table.rows).toEqual [expected_rows[1], expected_rows[0], expected_rows[2]]

    it "makes columns sortable which are declared at-sortable", () ->
      @gui.table.sort(1)
      expect(@gui.table.rows).toEqual [expected_rows[2], expected_rows[0], expected_rows[1]]

    it "leaves columns unsortable if at-sortable is not declared", () ->
      @gui.table.sort(2)
      expect(@gui.table.rows).toEqual [expected_rows[1], expected_rows[0], expected_rows[2]]

    it "reloads the table if the entries change but the length doesn't", () ->
      @gui.alter_scope((scope_wrapper, vars) ->
        cities = scope_wrapper.get("cities")
        cities.pop()
        cities.push({id: 3, name: "Berlin", country: "Germany"})
      )
      expect(@gui.table.rows).toEqual [expected_rows[1], expected_rows[0], expected_rows[3]]
