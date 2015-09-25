paginationTemplate = "
<div style='margin: 0px;'>
  <ul class='pagination'>
    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='stepPage(-numberOfPages)'>{{getpaginatorLabels().first}}</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='jumpBack()'>{{getpaginatorLabels().jumpBack}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() <= 0}'>
      <a href='' ng-click='stepPage(-1)'>{{getpaginatorLabels().stepBack}}</a>
    </li>

    <li ng-class='{active: getCurrentPage() == page}' ng-repeat='page in pageSequence.data'>
      <a href='' ng-click='goToPage(page)'>{{page + 1}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='stepPage(1)'>{{getpaginatorLabels().stepAhead}}</a>
    </li>

    <li ng-show='showSectioning()' ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='jumpAhead()'>{{getpaginatorLabels().jumpAhead}}</a>
    </li>

    <li ng-class='{disabled: getCurrentPage() >= numberOfPages - 1}'>
      <a href='' ng-click='stepPage(numberOfPages)'>{{getpaginatorLabels().last}}</a>
    </li>
  </ul>
</div>"
