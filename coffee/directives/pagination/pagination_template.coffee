paginationTemplate = "
<div style='margin: 0px;'>
  <ul class='pagination'>
    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='stepPage(-numberOfPages)'>First</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='jumpBack()'>&laquo;</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='stepPage(-1)'>&lsaquo;</a>
    </li>

    <li ng-class='{active: getCurrentPage() == page}' ng-repeat='page in pageSequence.data'>
      <a href='' ng-click='goToPage(page)' ng-bind='page + 1'></a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='stepPage(1)'>&rsaquo;</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='jumpAhead()'>&raquo;</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='stepPage(numberOfPages)'>Last</a>
    </li>
  </ul>
</div>"
