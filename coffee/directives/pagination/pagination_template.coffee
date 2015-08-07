paginationTemplate = "
<div style='margin: 0px;'>
  <ul class='pagination'>
    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='stepPage(-numberOfPages)'>{{getPaginatorLabel().first}}</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='jumpBack()'>{{getPaginatorLabel().jumpBack}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='stepPage(-1)'>{{getPaginatorLabel().stepBack}}</a>
    </li>

    <li ng-class='{active: getCurrentPage() == page}' ng-repeat='page in pageSequence.data'>
      <a href='' ng-click='goToPage(page)'>{{page + 1}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='stepPage(1)'>{{getPaginatorLabel().stepAhead}}</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='jumpAhead()'>{{getPaginatorLabel().jumpAhead}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='stepPage(numberOfPages)'>{{getPaginatorLabel().last}}</a>
    </li>
  </ul>
</div>"
