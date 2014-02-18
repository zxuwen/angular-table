angular.module("angular-table").directive "atPagination", ["angularTableManager", (angularTableManager) ->
  {
    replace: true
    restrict: "E"

    template: "
      <div style='margin: 0px;'>
        <ul class='pagination'>
          <li ng-class='{disabled: #{irk_current_page} <= 0}'>
            <a href='' ng-click='step_page(-#{irk_number_of_pages})'>First</a>
          </li>

          <li ng-show='show_sectioning()' ng-class='{disabled: #{irk_current_page} <= 0}'>
            <a href='' ng-click='jump_back()'>&laquo;</a>
          </li>

          <li ng-class='{disabled: #{irk_current_page} <= 0}'>
            <a href='' ng-click='step_page(-1)'>&lsaquo;</a>
          </li>

          <li ng-class='{active: #{irk_current_page} == page}' ng-repeat='page in pages'>
            <a href='' ng-click='go_to_page(page)'>{{page + 1}}</a>
          </li>

          <li ng-class='{disabled: #{irk_current_page} >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='step_page(1)'>&rsaquo;</a>
          </li>

          <li ng-show='show_sectioning()' ng-class='{disabled: #{irk_current_page} >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='jump_ahead()'>&raquo;</a>
          </li>

          <li ng-class='{disabled: #{irk_current_page} >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='step_page(#{irk_number_of_pages})'>Last</a>
          </li>
        </ul>
      </div>"

    controller: ["$scope", "$element", "$attrs",
    ($scope, $element, $attrs) ->
      angularTableManager.register_pagination_scope($attrs.atTableId, $scope)
    ]

    scope: true

    link: ($scope, $element, $attributes) ->
      tc = angularTableManager.get_table_configuration($attributes.atTableId)

      $scope[irk_current_page] = 0

      generate_page_array = (start, end) ->
        x for x in [start..end]

      update = (reset) ->
        if $scope[tc.list]
          if $scope[tc.list].length > 0
            $scope[irk_number_of_pages] = Math.ceil($scope[tc.list].length / $scope[tc.items_per_page])
            $scope[irk_current_page] = keep_in_bounds($scope[irk_current_page], 0, $scope[irk_number_of_pages] - 1)
            console.log "current page after update: ", $scope[irk_current_page]
            if $scope.show_sectioning()
              # $scope.pages = generate_page_array(0, $scope[tc.max_pages] - 1)
              $scope.update_sectioning()
            else
              $scope.pages = generate_page_array(0, $scope[irk_number_of_pages] - 1)
          else
            $scope[irk_number_of_pages] = 1
            $scope.pages = [0]

      keep_in_bounds = (val, min, max) ->
        val = Math.max(min, val)
        Math.min(max, val)

      $scope.show_sectioning = () ->
        tc.max_pages && $scope[irk_number_of_pages] > $scope[tc.max_pages]

      shift_sectioning = (current_start, steps, length, upper_bound) ->
        new_start = current_start + steps
        if new_start > (upper_bound - length)
          upper_bound - length
        else if new_start < 0
          0
        else
          new_start
        $scope.pages = generate_page_array(new_start, new_start + parseInt($scope[tc.max_pages]) - 1)

      $scope.update_sectioning = () ->

        console.log "last displayed page: ", $scope.pages[$scope.pages.length - 1]
        console.log "current page: ", $scope[irk_current_page]

        new_start = undefined
        if $scope.pages[0] > $scope[irk_current_page]
          diff = $scope.pages[0] - $scope[irk_current_page]
          shift_sectioning($scope.pages[0], -diff, $scope[tc.max_pages], $scope[irk_number_of_pages])
        else if $scope.pages[$scope.pages.length - 1] < $scope[irk_current_page]
          diff = $scope[irk_current_page] - $scope.pages[$scope.pages.length - 1]
          shift_sectioning($scope.pages[0], diff, $scope[tc.max_pages], $scope[irk_number_of_pages])
        else if $scope.pages[$scope.pages.length - 1] > $scope[irk_number_of_pages]
          diff = $scope[irk_current_page] - $scope.pages[$scope.pages.length - 1]
          console.log diff
          shift_sectioning($scope.pages[0], diff, $scope[tc.max_pages], $scope[irk_number_of_pages])


      $scope.step_page = (step) ->
        step = parseInt(step)
        $scope[irk_current_page] = keep_in_bounds($scope[irk_current_page] + step, 0, $scope[irk_number_of_pages] - 1)
        $scope.update_sectioning()

      $scope.go_to_page = (page) ->
        $scope[irk_current_page] = page

      $scope.jump_back = () ->
        $scope.step_page(-$scope[tc.max_pages])

      $scope.jump_ahead = () ->
        $scope.step_page($scope[tc.max_pages])

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
