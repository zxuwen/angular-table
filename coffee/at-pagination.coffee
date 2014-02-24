class PageSequence

  generate: (start) ->
    if start > (@upper_bound - @length)
      start = @upper_bound - @length
    else if start < @lower_bound
      start = @lower_bound
    x for x in [start..(parseInt(start) + parseInt(@length) - 1)]

  constructor: (@lower_bound = 0, @upper_bound = 1, start = 0, @length = 1) ->
    throw "sequence is too long" if @length > (@upper_bound - @lower_bound)
    @data = @generate(start)

  reset_parameters: (lower_bound, upper_bound, length) ->
    @lower_bound = lower_bound
    @upper_bound = upper_bound
    @length = length
    throw "sequence is too long" if @length > (@upper_bound - @lower_bound)
    @data = @generate(@data[0])

  relocate: (distance) ->
    new_start = @data[0] + distance
    @data = @generate(new_start, new_start + @length)

  realign_greedy: (page) ->
    if page < @data[0]
      new_start = page
      @data = @generate(new_start)
    else if page > @data[@length - 1]
      new_start = page - (@length - 1)
      @data = @generate(new_start)

  realign_generous: (page) ->

angular.module("angular-table").directive "atPagination", ["angularTableManager", (angularTableManager) ->
  {
    restrict: "E"
    scope: true
    replace: true
    template: "
      <div style='margin: 0px;'>
        <ul class='pagination'>
          <li ng-class='{disabled: get_current_page() <= 0}'>
            <a href='' ng-click='step_page(-#{irk_number_of_pages})'>First</a>
          </li>

          <li ng-show='show_sectioning()' ng-class='{disabled: get_current_page() <= 0}'>
            <a href='' ng-click='jump_back()'>&laquo;</a>
          </li>

          <li ng-class='{disabled: get_current_page() <= 0}'>
            <a href='' ng-click='step_page(-1)'>&lsaquo;</a>
          </li>

          <li ng-class='{active: get_current_page() == page}' ng-repeat='page in page_sequence.data'>
            <a href='' ng-click='go_to_page(page)'>{{page + 1}}</a>
          </li>

          <li ng-class='{disabled: get_current_page() >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='step_page(1)'>&rsaquo;</a>
          </li>

          <li ng-show='show_sectioning()' ng-class='{disabled: get_current_page() >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='jump_ahead()'>&raquo;</a>
          </li>

          <li ng-class='{disabled: get_current_page() >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='step_page(#{irk_number_of_pages})'>Last</a>
          </li>
        </ul>
      </div>"

    link: ($scope, $element, $attributes) ->
      tc = angularTableManager.get_table_configuration($attributes.atTableId)

      w = new ScopeConfigWrapper($scope, tc)

      $scope.page_sequence = new PageSequence()

      set_current_page = (current_page) ->
        $scope.$parent.$eval("#{tc.current_page}=#{current_page}")

      get_number_of_pages = () ->
        $scope[irk_number_of_pages]

      set_number_of_pages = (number_of_pages) ->
        $scope[irk_number_of_pages] = number_of_pages

      update = (reset) ->
        if $scope[tc.list]
          if $scope[tc.list].length > 0
            # old_number_of_pages = get_number_of_pages()
            new_number_of_pages = Math.ceil($scope[tc.list].length / w.get_items_per_page())
            # if (old_number_of_pages != new_number_of_pages)
            set_number_of_pages(new_number_of_pages)
            if $scope.show_sectioning()
              pages_to_display = w.get_max_pages()
            else
              pages_to_display = new_number_of_pages

            $scope.page_sequence.reset_parameters(0, new_number_of_pages, pages_to_display)
            # TODO warum ist die reihenfolge der folgenden beiden aufrufe irrelevant?
            set_current_page(keep_in_bounds(w.get_current_page(), 0, get_number_of_pages() - 1))
            $scope.page_sequence.realign_greedy(w.get_current_page())
          else
            set_number_of_pages(1)
            $scope.page_sequence.reset_parameters(0, 1, 1)
            set_current_page(0)
            $scope.page_sequence.realign_greedy(0)

      keep_in_bounds = (val, min, max) ->
        val = Math.max(min, val)
        Math.min(max, val)

      $scope.show_sectioning = () ->
        w.get_max_pages() && get_number_of_pages() > w.get_max_pages()

      $scope.get_current_page = () ->
        w.get_current_page()

      $scope.step_page = (step) ->
        step = parseInt(step)
        set_current_page(keep_in_bounds(w.get_current_page() + step, 0, get_number_of_pages() - 1))
        $scope.page_sequence.realign_greedy(w.get_current_page())

      $scope.go_to_page = (page) ->
        set_current_page(page)

      $scope.jump_back = () ->
        $scope.step_page(-w.get_max_pages())

      $scope.jump_ahead = () ->
        $scope.step_page(w.get_max_pages())

      update()

      $scope.$watch tc.items_per_page, () ->
        update()

      $scope.$watch tc.max_pages, () ->
        update()

      $scope.$watch tc.list, () ->
        update()

      $scope.$watch "#{tc.list}.length", () ->
        update()

  }
]
