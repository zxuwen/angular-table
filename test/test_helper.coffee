getChildrenFor = (element, selector) ->
  element[0].querySelectorAll(selector)

extract_html_to_array = (tds) ->
  _.map(tds, (td) -> angular.element(td).html())

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