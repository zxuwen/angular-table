describe "angular-table", () ->
  describe "Pagination", () ->

    step_back  = '‹'
    step_ahead = '›'
    jump_back  = '«'
    jump_ahead = '»'
    first      = 'First'
    last       = 'Last'

    setups = [
      {
        template: "pagination/complete_config_hardcoded.html"
        variable_names: {
          items_per_page: "completeConfigHardcoded_itemsPerPage",
          max_pages:      "completeConfigHardcoded_maxPages"
        }
      },
      {
        template: "pagination/complete_config_parameterized.html"
        variable_names: {
          items_per_page: "config.my_items_per_page",
          max_pages:      "config.my_max_pages"
        }
      }
    ]

    for setup in setups
      do (setup) ->
        describe "complete configuration hardcoded #{setup.template}", () ->
          beforeEach () ->
            @comp = new TemplateCompiler(setup.template)

            @element = @comp.prepare_element((scope) ->
              scope.list = [
                {name: "g"}, {name: "h"}, {name: "i"}, {name: "j"}, {name: "k"}, {name: "l"}
                {name: "a"}, {name: "b"}, {name: "c"}, {name: "d"}, {name: "e"}, {name: "f"},
                {name: "m"}
              ]
            )

            @gui = new GUI(@element, @comp.scope, setup.variable_names)

          it "allows to select pages", () ->

            expect(@gui.pagination.pages).toEqual([1, 2])
            expect(@gui.pagination.current_page).toEqual(1)

            @gui.alter_scope((scope_wrapper, vars) ->
              scope_wrapper.set(vars.items_per_page, 4)
              scope_wrapper.set(vars.max_pages, 4)
            )

            expect(@gui.table.rows).toEqual([['a'], ['b'], ['c'], ['d']])
            expect(@gui.pagination.pages).toEqual([1, 2, 3, 4])

            @gui.click_pagination(2)

            expect(@gui.table.rows).toEqual([['e'], ['f'], ['g'], ['h']])
            expect(@gui.pagination.current_page).toEqual(2)

            @gui.click_pagination(4)

            expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;'], ['&nbsp;']])
            expect(@gui.pagination.current_page).toEqual(4)

          it "allows to step back and forth", () ->
            expect(@gui.table.rows).toEqual([['a'], ['b'], ['c']])
            expect(@gui.pagination.current_page).toEqual(1)
            expect(@gui.pagination.pages).toEqual([1, 2])

            @gui.click_pagination(step_ahead)

            expect(@gui.table.rows).toEqual([['d'], ['e'], ['f']])
            expect(@gui.pagination.current_page).toEqual(2)
            expect(@gui.pagination.pages).toEqual([1, 2])

            @gui.click_pagination(step_ahead)

            expect(@gui.table.rows).toEqual([['g'], ['h'], ['i']])
            expect(@gui.pagination.current_page).toEqual(3)
            expect(@gui.pagination.pages).toEqual([2, 3])

            @gui.click_pagination(step_ahead)
            @gui.click_pagination(step_ahead)

            # we reached the end of the pagination by now

            expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;']])
            expect(@gui.pagination.current_page).toEqual(5)
            expect(@gui.pagination.pages).toEqual([4, 5])

            @gui.click_pagination(step_ahead)

            expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;']])
            expect(@gui.pagination.current_page).toEqual(5)
            expect(@gui.pagination.pages).toEqual([4, 5])

            @gui.click_pagination(step_back)

            expect(@gui.table.rows).toEqual([['j'], ['k'], ['l']])
            expect(@gui.pagination.current_page).toEqual(4)
            expect(@gui.pagination.pages).toEqual([4, 5])

            @gui.click_pagination(step_back)

            expect(@gui.table.rows).toEqual([['g'], ['h'], ['i']])
            expect(@gui.pagination.current_page).toEqual(3)
            expect(@gui.pagination.pages).toEqual([3, 4])

          describe "the maximum pages setting", () ->
            for val in [undefined, null]
              it "shows all pages if max_pages is undefined or null", () ->

                @gui.alter_scope((scope_wrapper, vars) ->
                  scope_wrapper.set(vars.max_pages, val)
                )

                expect(@gui.pagination.pages).toEqual([1, 2, 3, 4, 5])
                expect(@gui.pagination.representation).toEqual(
                  ['First', '‹', '1', '2', '3', '4', '5', '›', 'Last'])

            it "shows a subsection of pages if maximum pages is smaller than total pages", () ->
              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.max_pages, 3)
              )

              expect(@gui.pagination.pages).toEqual([1, 2, 3])
              expect(@gui.pagination.representation).toEqual(
                  [ 'First', '«', '‹', '1', '2', '3', '›', '»', 'Last' ])
