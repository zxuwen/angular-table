getChildrenFor = (element, selector) ->
  element[0].querySelectorAll(selector)

extract_visible_elements = (elements) ->
  _.reject(elements, (element) ->
    angular.element(element).hasClass("ng-hide")
  )

extract_html_to_array = (elements) ->
  _.map(elements, (element) ->
    angular.element(element).html()
  )

class ScopeWrapper
  constructor: (@scope) ->

  set: (expression, value) ->
    @scope.$eval("#{expression}=#{value}")

  get: (expression) ->
    @scope.$eval("#{expression}")

class TemplateCompiler
  constructor: (template_name) ->
    @template_name = template_name
    module("angular-table")
    module("test/templates/#{@template_name}")

  load_template: (template_name, template_cache) ->
    angular.element(template_cache.get(template_name))

  compile_template: ($compile, $rootScope, $templateCache, callback) ->
    element = null

    element = @load_template("test/templates/#{@template_name}", $templateCache)
    callback($rootScope)
    element = $compile(element)($rootScope)
    $rootScope.$digest()

    @scope = $rootScope

    return element

  prepare_element: (callback) ->
    element = null
    thiz = @
    inject ($compile, $rootScope, $templateCache) ->
      element = thiz.compile_template($compile, $rootScope, $templateCache, callback)
    return element

class TableGUI
  constructor: (@element) ->
    @reload()

  reload: () ->
    @rows = _.map(@element.find("tr"), (row) ->
      _.map(angular.element(row).find("td"), (cell) ->
        angular.element(cell).html()
      )
    )
    @rows.shift() if @rows[0].length == 0

  sort: (i) ->
    click(@element.find("th")[i])
    @reload()


class PaginationGUI
  constructor: (@element) ->
    @reload()

  reload: () ->
    lis = @element.find("li")
    lis = extract_visible_elements(lis)
    as = (angular.element(li).find("a") for li in lis)

    @buttons = {}
    (@buttons[a.html()] = a[0]) for a in as

    @representation = (key for key, val of @buttons)

    @pages = []
    for p in @representation
      n = parseInt(p)
      @pages.push(n) if !isNaN(n)

    @current_page = _.find(lis, (li) -> angular.element(li).hasClass("active"))
    @current_page = parseInt(angular.element(@current_page).find("a").html())

  click: (button) ->
    click(@buttons[button])
    @reload()

class GUI
  constructor: (@element, @scope, @variable_names) ->
    @pagination = new PaginationGUI(@element)
    @table = new TableGUI(@element)

  reload: () ->
    @table.reload()
    @pagination.reload()

  alter_scope: (f) ->
    f(new ScopeWrapper(@scope), @variable_names)
    @scope.$digest()
    @reload()

  click_pagination: (button) ->
    @pagination.click(button)
    @table.reload()

click = (el) ->
  ev = document.createEvent("MouseEvent")
  ev.initMouseEvent "click", true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
  el.dispatchEvent ev
  return

# currently untested
# - enabled/disabled buttons
# - fill last page