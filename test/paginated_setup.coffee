describe "angular-table", () ->
  describe "paginated setup", () ->

    config_name = "table_config"
    list_name = "myList"

    step_back  = '‹'
    step_ahead = '›'
    jump_back  = '«'
    jump_ahead = '»'
    first      = 'First'
    last       = 'Last'

    setups = [{
        template: "paginated_setup.html"
        variable_names: {
          items_per_page: "#{config_name}.itemsPerPage",
          max_pages:      "#{config_name}.maxPages",
          sort_context:   "#{config_name}.sortContext",
          fill_last_page: "#{config_name}.fillLastPage"
        }
      }]

    for setup in setups
      do (setup) ->
        describe "complete configuration hardcoded #{setup.template}", () ->
          beforeEach () ->
            @comp = new TemplateCompiler(setup.template)

            @element = @comp.prepare_element((scope) ->
              scope[list_name] = [
                {name: "i"}, {name: "g"}, {name: "h"}, {name: "j"}, {name: "k"}, {name: "l"}
                {name: "a"}, {name: "b"}, {name: "c"}, {name: "d"}, {name: "e"}, {name: "f"},
                {name: "m"}
              ]

              scope[config_name] = {
                currentPage: 0,
                itemsPerPage: 3,
                maxPages: 2,
                sortContext: 'global',
                fillLastPage: true
              }
            )

            table = new TableGUI(@element)
            pagination = new PaginationGUI(@element)
            @gui = new GUI(table, pagination, @comp.scope, setup.variable_names)

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

          it "allows to jump back and forth", () ->
            expect(@gui.table.rows).toEqual([['a'], ['b'], ['c']])
            expect(@gui.pagination.current_page).toEqual(1)
            expect(@gui.pagination.pages).toEqual([1, 2])

            @gui.click_pagination(jump_ahead)

            expect(@gui.table.rows).toEqual([['g'], ['h'], ['i']])
            expect(@gui.pagination.current_page).toEqual(3)
            expect(@gui.pagination.pages).toEqual([2, 3])

            @gui.click_pagination(jump_ahead)

            # we reached the end of the pagination by now

            expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;']])
            expect(@gui.pagination.current_page).toEqual(5)
            expect(@gui.pagination.pages).toEqual([4, 5])

            @gui.click_pagination(jump_ahead)

            expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;']])
            expect(@gui.pagination.current_page).toEqual(5)
            expect(@gui.pagination.pages).toEqual([4, 5])

            @gui.click_pagination(step_back)

            expect(@gui.table.rows).toEqual([['j'], ['k'], ['l']])
            expect(@gui.pagination.current_page).toEqual(4)
            expect(@gui.pagination.pages).toEqual([4, 5])

            @gui.click_pagination(jump_back)

            expect(@gui.table.rows).toEqual([['d'], ['e'], ['f']])
            expect(@gui.pagination.current_page).toEqual(2)
            expect(@gui.pagination.pages).toEqual([2, 3])

            @gui.click_pagination(jump_back)

            expect(@gui.table.rows).toEqual([['a'], ['b'], ['c']])
            expect(@gui.pagination.current_page).toEqual(1)
            expect(@gui.pagination.pages).toEqual([1, 2])

          it "allows to set a sort context", () ->
            @gui.alter_scope((scope_wrapper, vars) ->
              scope_wrapper.set(vars.items_per_page, 4)
              scope_wrapper.set(vars.sort_context, "global")
            )

            expect(@gui.table.rows).toEqual([['a'], ['b'], ['c'], ['d']])

            @gui.table.sort(0)

            expect(@gui.table.rows).toEqual([['m'], ['l'], ['k'], ['j']])

            @gui.alter_scope((scope_wrapper, vars) ->
              scope_wrapper.set(vars.sort_context, "page")
            )

            expect(@gui.table.rows).toEqual([['j'], ['i'], ['h'], ['g']])

            @gui.table.sort(0)

            expect(@gui.table.rows).toEqual([['g'], ['h'], ['i'], ['j']])

          it "shows an empty table if fill-last-page is true and the list is empty", () ->
            @gui.click_pagination(2)

            expect(@gui.table.rows).toEqual [['d'], ['e'], ['f']]
            expect(@gui.pagination.current_page).toEqual 2

            @gui.alter_scope((scope_wrapper, vars) ->
              scope_wrapper.set(vars.items_per_page, 3)
              scope_wrapper.set(vars.fill_last_page, true)
              scope_wrapper.set(list_name, [])
            )

            expect(@gui.table.rows).toEqual [['&nbsp;'], ['&nbsp;'], ['&nbsp;']]
            expect(@gui.pagination.pages).toEqual [1]
            expect(@gui.pagination.current_page).toEqual 1

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

          describe "heavy interaction", () ->
            it "updates when the length of the list changes", () ->
              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 3)
                scope_wrapper.set(vars.max_pages, 2)
                scope_wrapper.set(list_name, [{name: 'z'}])
              )

              expect(@gui.table.rows).toEqual [['z'], ['&nbsp;'], ['&nbsp;']]

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.get(list_name).push({name: 'a'})
              )

              expect(@gui.table.rows).toEqual [['a'], ['z'], ['&nbsp;']]
              expect(@gui.pagination.representation).toEqual ['First', '‹', '1', '›', 'Last']
              expect(@gui.pagination.pages).toEqual [1]

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.get(list_name).push({name: 'x'})
                scope_wrapper.get(list_name).push({name: 'b'})
              )

              expect(@gui.table.rows).toEqual [['a'], ['b'], ['x']]
              expect(@gui.pagination.representation).toEqual ['First', '‹', '1', '2', '›', 'Last']
              expect(@gui.pagination.pages).toEqual [1, 2]

              @gui.click_pagination(2)

              expect(@gui.table.rows).toEqual [['z'], ['&nbsp;'], ['&nbsp;']]

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.get(list_name).push({name: 'c'})
                scope_wrapper.get(list_name).push({name: 'y'})
                scope_wrapper.get(list_name).push({name: 'u'})
              )

              expect(@gui.table.rows).toEqual [['u'], ['x'], ['y']]
              expect(@gui.pagination.representation).toEqual(
                  [ 'First', '«', '‹', '1', '2', '›', '»', 'Last' ])

              @gui.click_pagination(step_ahead)

              expect(@gui.table.rows).toEqual [['z'], ['&nbsp;'], ['&nbsp;']]
              expect(@gui.pagination.representation).toEqual(
                  [ 'First', '«', '‹', '2', '3', '›', '»', 'Last' ])


            it "updates when ever a configuration parameter changes", () ->
              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 5)
                scope_wrapper.set(vars.max_pages, 4)
              )

              @gui.click_pagination(step_ahead)

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['f'], ['g'], ['h'], ['i'], ['j']])
              expect(@gui.pagination.pages).toEqual([1, 2, 3])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.max_pages, 2)
              )

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['f'], ['g'], ['h'], ['i'], ['j']])
              expect(@gui.pagination.pages).toEqual([1, 2])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.max_pages, 1)
              )

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['f'], ['g'], ['h'], ['i'], ['j']])
              expect(@gui.pagination.pages).toEqual([2])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 2)
              )

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['c'], ['d']])
              expect(@gui.pagination.pages).toEqual([2])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 3)
              )

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['d'], ['e'], ['f']])
              expect(@gui.pagination.pages).toEqual([2])

              @gui.click_pagination(step_ahead)

              expect(@gui.pagination.current_page).toEqual 3
              expect(@gui.table.rows).toEqual([['g'], ['h'], ['i']])
              expect(@gui.pagination.pages).toEqual([3])

              @gui.click_pagination(step_ahead)
              @gui.click_pagination(step_ahead)

              expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;']])
              expect(@gui.pagination.current_page).toEqual(5)
              expect(@gui.pagination.pages).toEqual([5])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.max_pages, 3)
              )

              expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;']])
              expect(@gui.pagination.current_page).toEqual(5)
              expect(@gui.pagination.pages).toEqual([3, 4, 5])

              @gui.click_pagination(jump_back)

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['d'], ['e'], ['f']])
              expect(@gui.pagination.pages).toEqual([2, 3, 4])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.max_pages, 4)
              )

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['d'], ['e'], ['f']])
              expect(@gui.pagination.pages).toEqual([2, 3, 4, 5])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 6)
              )

              expect(@gui.pagination.current_page).toEqual 2
              expect(@gui.table.rows).toEqual([['g'], ['h'], ['i'], ['j'], ['k'], ['l']])
              expect(@gui.pagination.pages).toEqual([1, 2, 3])

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 2)
                scope_wrapper.set(vars.max_pages, 2)
              )

              @gui.click_pagination(jump_ahead)

              expect(@gui.pagination.current_page).toEqual 4

              @gui.click_pagination(jump_ahead)

              expect(@gui.pagination.current_page).toEqual 6

              @gui.click_pagination(jump_ahead)

              expect(@gui.pagination.current_page).toEqual 7

              @gui.alter_scope((scope_wrapper, vars) ->
                scope_wrapper.set(vars.items_per_page, 6)
                scope_wrapper.set(vars.max_pages, 4)
              )

              expect(@gui.table.rows).toEqual([['m'], ['&nbsp;'], ['&nbsp;'], ['&nbsp;'], ['&nbsp;'], ['&nbsp;']])
              expect(@gui.pagination.current_page).toEqual(3)
              expect(@gui.pagination.pages).toEqual([1, 2, 3])