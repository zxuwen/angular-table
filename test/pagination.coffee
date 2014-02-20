describe "angular-table", () ->

  describe "PageSequence", () ->

    it "is constructed from upper_bound, lower_bound, start and length paramters", () ->
      sequence = new PageSequence(0, 10, 0, 5)
      expect(sequence.data).toEqual [0, 1, 2, 3, 4]

      sequence = new PageSequence(0, 10, 4, 3)
      expect(sequence.data).toEqual [4, 5, 6]

      sequence = new PageSequence(0, 5, 3, 4)
      expect(sequence.data).toEqual [1, 2, 3, 4]

    it "throws an exception when length does not fit into lower and upper bounds", () ->
      expect(() -> new PageSequence(0, 2, 0, 3)).toThrow()

    it "s parameters can be reset", () ->
      sequence = new PageSequence(0, 10, 4, 3)
      expect(sequence.data).toEqual [4, 5, 6]

      sequence.reset_parameters(0, 6, 3)
      expect(sequence.data).toEqual [3, 4, 5]

    it "relocates by a given distance and wont underrun or exceed a given boundary", () ->
      sequence = new PageSequence(0, 7, 0, 3)
      expect(sequence.data).toEqual [0, 1, 2]

      sequence.relocate(1)
      expect(sequence.data).toEqual [1, 2, 3]

      sequence.relocate(2)
      expect(sequence.data).toEqual [3, 4, 5]

      sequence.relocate(2)
      expect(sequence.data).toEqual [4, 5, 6]

    describe "realignment", () ->
      it "does not realign if the given page is in the current sequence scope", () ->
        sequence = new PageSequence(0, 7, 2, 3)
        expect(sequence.data).toEqual [2, 3, 4]

        sequence.realign_greedy(2)
        expect(sequence.data).toEqual [2, 3, 4]

        sequence.realign_greedy(4)
        expect(sequence.data).toEqual [2, 3, 4]

      it "realigns greedy", () ->
        sequence = new PageSequence(0, 7, 2, 3)
        expect(sequence.data).toEqual [2, 3, 4]

        sequence.realign_greedy(6)
        expect(sequence.data).toEqual [4, 5, 6]

        # expect(() -> sequence.realign_greedy(7)).toThrow()

        sequence.realign_greedy(4)
        expect(sequence.data).toEqual [4, 5, 6]

        sequence.realign_greedy(1)
        expect(sequence.data).toEqual [1, 2, 3]

        sequence.realign_greedy(0)
        expect(sequence.data).toEqual [0, 1, 2]

        # expect(() -> sequence.realign_greedy(-1)).toThrow()




  describe "pagination", () ->
    step_back  = '‹'
    step_ahead = '›'
    jump_back  = '«'
    jump_ahead = '»'
    first      = 'First'
    last       = 'Last'

    describe "complete configuration hardcoded", () ->

      beforeEach () ->
        @comp = new TemplateCompiler("pagination/complete_config_hardcoded.html")

        @element = @comp.prepare_element((scope) ->
          scope.list = [
            {name: "g"}, {name: "h"}, {name: "i"}, {name: "j"}, {name: "k"}, {name: "l"}
            {name: "a"}, {name: "b"}, {name: "c"}, {name: "d"}, {name: "e"}, {name: "f"},
            {name: "m"}
          ]
        )

        @gui = new GUI(@element, @comp.scope)

      it "allows to select pages", () ->
        expect(@gui.pagination.pages).toEqual [1, 2]
        expect(@gui.pagination.current_page).toEqual 1

        @gui.alter_scope((scope) ->
          scope.completeConfigHardcoded_itemsPerPage = 4
          scope.completeConfigHardcoded_maxPages = 4
        )

        expect(@gui.table.rows).toEqual [['a'], ['b'], ['c'], ['d']]
        expect(@gui.pagination.pages).toEqual [1, 2, 3, 4]

        @gui.click_pagination(2)

        expect(@gui.table.rows).toEqual [['e'], ['f'], ['g'], ['h']]
        expect(@gui.pagination.current_page).toEqual 2

        @gui.click_pagination(4)

        expect(@gui.table.rows).toEqual [['m'], ['&nbsp;'], ['&nbsp;'], ['&nbsp;']]
        expect(@gui.pagination.current_page).toEqual 4


      it "allows to step back and forth", () ->
        expect(@gui.table.rows).toEqual [['a'], ['b'], ['c']]

        expect(@gui.table.rows).toEqual [['a'], ['b'], ['c']]
        expect(@gui.pagination.current_page).toEqual 1
        expect(@gui.pagination.pages).toEqual [1, 2]

        @gui.click_pagination(step_ahead)

        expect(@gui.table.rows).toEqual [['d'], ['e'], ['f']]
        expect(@gui.pagination.current_page).toEqual 2
        expect(@gui.pagination.pages).toEqual [1, 2]

        @gui.click_pagination(step_ahead)

        expect(@gui.table.rows).toEqual [['g'], ['h'], ['i']]
        expect(@gui.pagination.current_page).toEqual 3
        expect(@gui.pagination.pages).toEqual [2, 3]

        @gui.click_pagination(step_ahead)
        @gui.click_pagination(step_ahead)

        # we reached the end of the pagination by now

        expect(@gui.table.rows).toEqual [['m'], ['&nbsp;'], ['&nbsp;']]
        expect(@gui.pagination.current_page).toEqual 5
        expect(@gui.pagination.pages).toEqual [4, 5]

        @gui.click_pagination(step_ahead)

        expect(@gui.table.rows).toEqual [['m'], ['&nbsp;'], ['&nbsp;']]
        expect(@gui.pagination.current_page).toEqual 5
        expect(@gui.pagination.pages).toEqual [4, 5]

        @gui.click_pagination(step_back)

        expect(@gui.table.rows).toEqual [['j'], ['k'], ['l']]
        expect(@gui.pagination.current_page).toEqual 4
        expect(@gui.pagination.pages).toEqual [4, 5]

        @gui.click_pagination(step_back)

        expect(@gui.table.rows).toEqual [['g'], ['h'], ['i']]
        expect(@gui.pagination.current_page).toEqual 3
        expect(@gui.pagination.pages).toEqual [3, 4]

    it "adds pagination to a table", () ->
      comp = new TemplateCompiler("pagination/pagination.html")
      @element = comp.prepare_element((scope) ->
        scope.rammstein = [
          {name: "Till"}, {name: "Richard"}, {name: "Christoph"},
          {name: "Paul"}, {name: "Flake"}, {name: "Oliver"}
        ]
      )

      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Till", "Richard", "Christoph", "Paul"]

      p = new PaginationGUI(@element)
      expect(p.pages).toEqual [1, 2]

      p.click(step_ahead)
      tds = extract_html_to_array(@element.find("td"))
      expect(tds).toEqual ["Flake", "Oliver", "&nbsp;", "&nbsp;"]

    describe "sort context", () ->
      callback = (scope) ->
        scope.letters = [{char: "c"}, {char: "b"}, {char: "d"}, {char: "f"},
                         {char: "a"}, {char: "e"}, {char: "h"}, {char: "g"}]

      it "allows to set the sort context to global", () ->
        comp = new TemplateCompiler("pagination/sort_context_global.html")
        @element = comp.prepare_element(callback)
        tds = extract_html_to_array(@element.find("td"))
        expect(tds).toEqual ["a", "b", "c", "d"]

      it "allows to set the sort context to page", () ->
        comp = new TemplateCompiler("pagination/sort_context_page.html")
        @element = comp.prepare_element(callback)
        tds = extract_html_to_array(@element.find("td"))
        expect(tds).toEqual ["b", "c", "d", "f"]
