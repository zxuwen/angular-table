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

extract_pagination_to_array = (elements) ->
  elements = extract_visible_elements(elements)
  angular.element(element).find("a").html() for element in elements

load_template = (template_name, template_cache) ->
  angular.element(template_cache.get(template_name))

prepare_element = (template_compiler, callback) ->
  element = null
  inject ($compile, $rootScope, $templateCache) ->
    element = template_compiler.compile_template($compile, $rootScope, $templateCache, callback)
  return element

class TemplateCompiler
  constructor : (template_name) ->
    @template_name = template_name

    module("angular-table")
    module("test/templates/#{@template_name}")

  compile_template : ($compile, $rootScope, $templateCache, callback) ->
    element = null

    element = load_template("test/templates/#{@template_name}", $templateCache)
    callback($rootScope)
    element = $compile(element)($rootScope)
    $rootScope.$digest()

    return element

click = (el) ->
  ev = document.createEvent("MouseEvent")
  ev.initMouseEvent "click", true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
  el.dispatchEvent ev
  return