angular.module("angular-table").directive "atPagination", [() ->
  restrict: "E"
  scope: true
  replace: true
  template: pagination_template

  link: ($scope, $element, $attributes) ->
    cvn = new ConfigurationVariableNames($attributes.atConfig)
    w = new ScopeConfigWrapper($scope, cvn, $attributes.atList)

    keep_in_bounds = (val, min, max) ->
      val = Math.max(min, val)
      Math.min(max, val)

    get_number_of_pages = () ->
      $scope[irk_number_of_pages]

    set_number_of_pages = (number_of_pages) ->
      $scope[irk_number_of_pages] = number_of_pages

    update = (reset) ->
      if w.get_list()
        if w.get_list().length > 0
          new_number_of_pages = Math.ceil(w.get_list().length / w.get_items_per_page())
          set_number_of_pages(new_number_of_pages)
          if $scope.show_sectioning()
            pages_to_display = w.get_max_pages()
          else
            pages_to_display = new_number_of_pages

          $scope.page_sequence.resetParameters(0, new_number_of_pages, pages_to_display)
          # TODO warum ist die reihenfolge der folgenden beiden aufrufe irrelevant?
          w.set_current_page(keep_in_bounds(w.get_current_page(), 0, get_number_of_pages() - 1))
          $scope.page_sequence.realignGreedy(w.get_current_page())
        else
          set_number_of_pages(1)
          $scope.page_sequence.resetParameters(0, 1, 1)
          w.set_current_page(0)
          $scope.page_sequence.realignGreedy(0)

    $scope.show_sectioning = () ->
      w.get_max_pages() && get_number_of_pages() > w.get_max_pages()

    $scope.get_current_page = () ->
      w.get_current_page()

    $scope.step_page = (step) ->
      step = parseInt(step)
      w.set_current_page(keep_in_bounds(w.get_current_page() + step, 0, get_number_of_pages() - 1))
      $scope.page_sequence.realignGreedy(w.get_current_page())

    $scope.go_to_page = (page) ->
      w.set_current_page(page)

    $scope.jump_back = () ->
      $scope.step_page(-w.get_max_pages())

    $scope.jump_ahead = () ->
      $scope.step_page(w.get_max_pages())

    $scope.page_sequence = new PageSequence()

    $scope.$watch cvn.items_per_page, () ->
      update()

    $scope.$watch cvn.max_pages, () ->
      update()

    $scope.$watch $attributes.atList, () ->
      update()

    $scope.$watch "#{$attributes.atList}.length", () ->
      update()

    update()
]