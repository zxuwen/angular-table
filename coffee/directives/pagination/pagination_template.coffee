pagination_template = "
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
