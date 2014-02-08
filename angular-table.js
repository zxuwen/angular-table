// author:   Samuel Mueller 
// version:  0.0.8 
// license:  MIT 
// homepage: http://github.com/samu/angular-table 
(function() {
  angular.module("angular-table", []);

  angular.module("angular-table").directive("atTable", [
    "metaCollector", "setupFactory", function(metaCollector, setupFactory) {
      var constructHeader, normalizeInput, validateInput;
      constructHeader = function(customHeaderMarkup, bodyDefinitions) {
        var attribute, icon, td, th, title, tr, _i, _j, _len, _len1, _ref;
        tr = angular.element(document.createElement("tr"));
        for (_i = 0, _len = bodyDefinitions.length; _i < _len; _i++) {
          td = bodyDefinitions[_i];
          th = angular.element(document.createElement("th"));
          th.attr("style", "cursor: pointer;");
          if (customHeaderMarkup[td.attribute]) {
            _ref = customHeaderMarkup[td.attribute].attributes;
            for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
              attribute = _ref[_j];
              th.attr("" + attribute.name, "" + attribute.value);
            }
            title = customHeaderMarkup[td.attribute].content;
          } else {
            title = td.title;
          }
          th.html("" + title);
          if (td.sortable) {
            th.attr("ng-click", "predicate = '" + td.attribute + "'; descending = !descending;");
            icon = angular.element("<i style='margin-left: 10px;'></i>");
            icon.attr("ng-class", "getSortIcon('" + td.attribute + "')");
            th.append(icon);
          }
          th.attr("width", td.width);
          tr.append(th);
        }
        return tr;
      };
      validateInput = function(attributes) {
        if (attributes.pagination && attributes.atList) {
          throw "You can not specify a list if you have specified a pagination. The list defined for the pagnination will automatically be used.";
        }
        if (!attributes.pagination && !attributes.atList) {
          throw "Either a list or pagination must be specified.";
        }
      };
      normalizeInput = function(attributes) {
        if (attributes.atPagination) {
          attributes.pagination = attributes.atPagination;
          return attributes.atPagination = null;
        }
      };
      return {
        restrict: "AC",
        scope: true,
        compile: function(element, attributes, transclude) {
          var bodyDefinition, customHeaderMarkup, header, setup, thead, tr;
          normalizeInput(attributes);
          validateInput(attributes);
          bodyDefinition = metaCollector.collectBodyDefinition(element);
          thead = element.find("thead");
          if (thead[0]) {
            customHeaderMarkup = metaCollector.collectCustomHeaderMarkup(element);
            tr = angular.element(thead).find("tr");
            tr.remove();
            header = constructHeader(customHeaderMarkup, bodyDefinition.tds);
            angular.element(thead[0]).append(header);
          }
          setup = setupFactory(attributes);
          setup.compile(element, attributes, transclude);
          return {
            post: function($scope, $element, $attributes) {
              if (bodyDefinition.initialSorting) {
                $scope.predicate = bodyDefinition.initialSorting.predicate;
                $scope.descending = bodyDefinition.initialSorting.direction === "desc";
              }
              $scope.getSortIcon = function(predicate) {
                if (predicate !== $scope.predicate) {
                  return "icon-minus";
                }
                if ($scope.descending) {
                  return "icon-chevron-down";
                } else {
                  return "icon-chevron-up";
                }
              };
              return setup.link($scope, $element, $attributes);
            }
          };
        }
      };
    }
  ]);

  angular.module("angular-table").directive("atImplicit", [
    function() {
      return {
        restrict: "AC",
        compile: function(element, attributes, transclude) {
          var attribute;
          attribute = element.attr("at-attribute");
          if (!attribute) {
            throw "at-implicit specified without at-attribute: " + (element.html());
          }
          return element.append("{{item." + attribute + "}}");
        }
      };
    }
  ]);

  angular.module("angular-table").directive("atPagination", [
    function() {
      return {
        replace: true,
        restrict: "E",
        template: "      <div class='pagination' style='margin: 0px;'>        <ul>          <li ng-class='{disabled: currentPage <= 0}'>            <a href='' ng-click='goToPage(currentPage - 1)'>&laquo;</a>          </li>          <li ng-class='{active: currentPage == page}' ng-repeat='page in pages'>            <a href='' ng-click='goToPage(page)'>{{page + 1}}</a>          </li>          <li ng-class='{disabled: currentPage >= numberOfPages - 1}'>            <a href='' ng-click='goToPage(currentPage + 1); normalize()'>&raquo;</a>          </li>        </ul>      </div>",
        scope: {
          atItemsPerPage: "@",
          atInstance: "=",
          atList: "="
        },
        link: function($scope, $element, $attributes) {
          var normalizePage, update;
          $scope.atInstance = $scope;
          $scope.currentPage = 0;
          normalizePage = function(page) {
            page = Math.max(0, page);
            page = Math.min($scope.numberOfPages - 1, page);
            return page;
          };
          update = function(reset) {
            var x;
            $scope.currentPage = 0;
            if ($scope.atList) {
              if ($scope.atList.length > 0) {
                $scope.numberOfPages = Math.ceil($scope.atList.length / $scope.atItemsPerPage);
                return $scope.pages = (function() {
                  var _i, _ref, _results;
                  _results = [];
                  for (x = _i = 0, _ref = $scope.numberOfPages - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
                    _results.push(x);
                  }
                  return _results;
                })();
              } else {
                $scope.numberOfPages = 1;
                return $scope.pages = [0];
              }
            }
          };
          $scope.fromPage = function() {
            if ($scope.atList) {
              return $scope.atItemsPerPage * $scope.currentPage - $scope.atList.length;
            }
          };
          $scope.getFillerArray = function() {
            var fillerLength, itemCountOnLastPage, x, _i, _ref, _ref1, _results;
            if ($scope.currentPage === $scope.numberOfPages - 1) {
              itemCountOnLastPage = $scope.atList.length % $scope.atItemsPerPage;
              if (itemCountOnLastPage !== 0 || $scope.atList.length === 0) {
                fillerLength = $scope.atItemsPerPage - itemCountOnLastPage - 1;
                _results = [];
                for (x = _i = _ref = $scope.atList.length, _ref1 = $scope.atList.length + fillerLength; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; x = _ref <= _ref1 ? ++_i : --_i) {
                  _results.push(x);
                }
                return _results;
              } else {
                return [];
              }
            }
          };
          $scope.goToPage = function(page) {
            return $scope.currentPage = normalizePage(page);
          };
          update();
          $scope.$watch("atItemsPerPage", function() {
            return update();
          });
          return $scope.$watch("atList", function() {
            return update();
          });
        }
      };
    }
  ]);

  angular.module("angular-table").service("metaCollector", [
    function() {
      var capitaliseFirstLetter, extractWidth, getInitialSortDirection, isSortable;
      capitaliseFirstLetter = function(string) {
        if (string) {
          return string.charAt(0).toUpperCase() + string.slice(1);
        } else {
          return "";
        }
      };
      extractWidth = function(classes) {
        var width;
        width = /([0-9]+px)/i.exec(classes);
        if (width) {
          return width[0];
        } else {
          return "";
        }
      };
      isSortable = function(classes) {
        var sortable;
        sortable = /(sortable)/i.exec(classes);
        if (sortable) {
          return true;
        } else {
          return false;
        }
      };
      getInitialSortDirection = function(td) {
        var initialSorting;
        initialSorting = td.attr("at-initial-sorting");
        if (initialSorting) {
          if (initialSorting === "asc" || initialSorting === "desc") {
            return initialSorting;
          }
          throw "Invalid value for initial-sorting: " + initialSorting + ". Allowed values are 'asc' or 'desc'.";
        }
        return void 0;
      };
      return {
        collectCustomHeaderMarkup: function(thead) {
          var customHeaderMarkup, customHeaderMarkups, th, tr, _i, _len, _ref;
          customHeaderMarkups = {};
          tr = thead.find("tr");
          _ref = tr.find("th");
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            th = _ref[_i];
            th = angular.element(th);
            customHeaderMarkup = customHeaderMarkups[th.attr("at-attribute")] = {};
            customHeaderMarkup.content = th.html();
            customHeaderMarkup.attributes = th[0].attributes;
          }
          return customHeaderMarkups;
        },
        collectBodyDefinition: function(tbody) {
          var attribute, bodyDefinition, initialSortDirection, sortable, td, title, width, _i, _len, _ref;
          bodyDefinition = {};
          bodyDefinition.tds = [];
          bodyDefinition.initialSorting = void 0;
          _ref = tbody.find("td");
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            td = _ref[_i];
            td = angular.element(td);
            attribute = td.attr("at-attribute");
            title = td.attr("at-title") || capitaliseFirstLetter(td.attr("at-attribute"));
            sortable = td.attr("at-sortable") !== void 0 || isSortable(td.attr("class"));
            width = extractWidth(td.attr("class"));
            bodyDefinition.tds.push({
              attribute: attribute,
              title: title,
              sortable: sortable,
              width: width
            });
            initialSortDirection = getInitialSortDirection(td);
            if (initialSortDirection) {
              if (!attribute) {
                throw "initial-sorting specified without attribute.";
              }
              bodyDefinition.initialSorting = {};
              bodyDefinition.initialSorting.direction = initialSortDirection;
              bodyDefinition.initialSorting.predicate = attribute;
            }
          }
          return bodyDefinition;
        }
      };
    }
  ]);

  angular.module("angular-table").factory("setupFactory", [
    function() {
      var PaginationSetup, StandardSetup, limitToExpression, orderByExpression, setupTr;
      orderByExpression = "| orderBy:predicate:descending";
      limitToExpression = "| limitTo:fromPage() | limitTo:toPage()";
      setupTr = function(element, repeatString) {
        var tbody, tr;
        tbody = element.find("tbody");
        tr = tbody.find("tr");
        tr.attr("ng-repeat", repeatString);
        return tbody;
      };
      StandardSetup = function(attributes) {
        var repeatString;
        repeatString = "item in " + attributes.atList + " " + orderByExpression;
        this.compile = function(element, attributes, transclude) {
          return setupTr(element, repeatString);
        };
        this.link = function() {};
      };
      PaginationSetup = function(attributes) {
        var paginationName, repeatString, sortContext;
        sortContext = attributes.atSortContext || "global";
        paginationName = attributes.pagination;
        if (sortContext === "global") {
          repeatString = "item in " + paginationName + ".atList " + orderByExpression + " " + limitToExpression;
        } else if (sortContext === "page") {
          repeatString = "item in " + paginationName + ".atList " + limitToExpression + " " + orderByExpression + " ";
        } else {
          throw "Invalid sort-context: " + sortContext + ".";
        }
        this.compile = function(element, attributes, transclude) {
          var fillerTr, tbody, td, tdString, tds, _i, _len;
          tbody = setupTr(element, repeatString);
          if (typeof attributes.atFillLastPage !== "undefined") {
            tds = element.find("td");
            tdString = "";
            for (_i = 0, _len = tds.length; _i < _len; _i++) {
              td = tds[_i];
              tdString += "<td>&nbsp;</td>";
            }
            fillerTr = angular.element(document.createElement("tr"));
            fillerTr.html(tdString);
            fillerTr.attr("ng-repeat", "item in " + paginationName + ".getFillerArray() ");
            return tbody.append(fillerTr);
          }
        };
        this.link = function($scope, $element, $attributes) {
          $scope.fromPage = function() {
            if ($scope[paginationName]) {
              return $scope[paginationName].fromPage();
            }
          };
          return $scope.toPage = function() {
            if ($scope[paginationName]) {
              return $scope[paginationName].atItemsPerPage;
            }
          };
        };
      };
      return function(attributes) {
        if (attributes.atList) {
          return new StandardSetup(attributes);
        }
        if (attributes.pagination) {
          return new PaginationSetup(attributes);
        }
      };
    }
  ]);

}).call(this);
