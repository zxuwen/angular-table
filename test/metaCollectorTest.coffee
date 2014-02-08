describe "angular-table", () ->
  describe "MetaCollector", () ->

    mc = null

    beforeEach () ->
      module("angular-table")
      inject (metaCollector) ->
        mc = metaCollector

    it "bla", () ->

      header = angular.element(
        "<table> <thead> <tr>
          <th at-attribute='one'>hello world</th>
        </tr> </thead> </table>"
      )

      headerMarkup = mc.collectCustomHeaderMarkup(header)

      one = headerMarkup["one"]

      expect(one).toBeDefined()
      expect(one["content"]).toEqual "hello world"
      expect(one["attributes"]).toBeDefined()
