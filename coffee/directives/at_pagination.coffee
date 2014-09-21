angular.module("angular-table").directive "atPagination", [() ->
  restrict: "E"
  scope: true
  replace: true
  template: paginationTemplate

  link: ($scope, $element, $attributes) ->
    cvn = new configuration_variable_names($attributes.atConfig)
    w = new ScopeConfigWrapper($scope, cvn, $attributes.atList)

    keep_in_bounds = (val, min, max) ->
      val = Math.max(min, val)
      Math.min(max, val)

    get_number_of_pages = () ->
      $scope[irkNumberOfPages]

    set_number_of_pages = (number_of_pages) ->
      $scope[irkNumberOfPages] = number_of_pages

    update = (reset) ->
      if w.getList()
        if w.getList().length > 0
          new_number_of_pages = Math.ceil(w.getList().length / w.getItemsPerPage())
          set_number_of_pages(new_number_of_pages)
          if $scope.showSectioning()
            pages_to_display = w.getMaxPages()
          else
            pages_to_display = new_number_of_pages

          $scope.page_sequence.resetParameters(0, new_number_of_pages, pages_to_display)
          # TODO warum ist die reihenfolge der folgenden beiden aufrufe irrelevant?
          w.setCurrentPage(keep_in_bounds(w.getCurrentPage(), 0, get_number_of_pages() - 1))
          $scope.page_sequence.realignGreedy(w.getCurrentPage())
        else
          set_number_of_pages(1)
          $scope.page_sequence.resetParameters(0, 1, 1)
          w.setCurrentPage(0)
          $scope.page_sequence.realignGreedy(0)

    $scope.showSectioning = () ->
      w.getMaxPages() && get_number_of_pages() > w.getMaxPages()

    $scope.getCurrentPage = () ->
      w.getCurrentPage()

    $scope.step_page = (step) ->
      step = parseInt(step)
      w.setCurrentPage(keep_in_bounds(w.getCurrentPage() + step, 0, get_number_of_pages() - 1))
      $scope.page_sequence.realignGreedy(w.getCurrentPage())

    $scope.go_to_page = (page) ->
      w.setCurrentPage(page)

    $scope.jump_back = () ->
      $scope.step_page(-w.getMaxPages())

    $scope.jump_ahead = () ->
      $scope.step_page(w.getMaxPages())

    $scope.page_sequence = new PageSequence()

    $scope.$watch cvn.itemsPerPage, () ->
      update()

    $scope.$watch cvn.maxPages, () ->
      update()

    $scope.$watch $attributes.atList, () ->
      update()

    $scope.$watch "#{$attributes.atList}.length", () ->
      update()

    update()
]