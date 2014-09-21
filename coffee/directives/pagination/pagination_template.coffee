paginationTemplate = "
<div style='margin: 0px;'>
  <ul class='pagination'>
    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='step_page(-#{irkNumberOfPages})'>First</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='jump_back()'>&laquo;</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='step_page(-1)'>&lsaquo;</a>
    </li>

    <li ng-class='{active: getCurrentPage() == page}' ng-repeat='page in page_sequence.data'>
      <a href='' ng-click='go_to_page(page)'>{{page + 1}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= #{irkNumberOfPages} - 1}'>
      <a href='' ng-click='step_page(1)'>&rsaquo;</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() >= #{irkNumberOfPages} - 1}'>
      <a href='' ng-click='jump_ahead()'>&raquo;</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= #{irkNumberOfPages} - 1}'>
      <a href='' ng-click='step_page(#{irkNumberOfPages})'>Last</a>
    </li>
  </ul>
</div>"
