// author:   Samuel Mueller 
// version:  0.0.8 
// license:  MIT 
// homepage: http://github.com/samu/angular-table 
(function() {
  var ColumnConfiguration, DeclarativeTable, PaginationTableSetup, StandardTableSetup, Table, TableSetup,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  angular.module("angular-table", []);

  angular.module("angular-table").directive("atTable", [
    function() {
      return {
        restrict: "AC",
        scope: true,
        compile: function(element, attributes, transclude) {
          var dt;
          dt = new DeclarativeTable(element, attributes);
          dt.compile();
          return {
            post: function($scope, $element, $attributes) {
              return dt.post($scope, $element, $attributes);
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

  Table = (function() {
    function Table() {}

    Table.prototype.constructHeader = function() {
      var i, tr, _i, _len, _ref;
      tr = angular.element(document.createElement("tr"));
      _ref = this.get_column_configurations();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        tr.append(i.render_html());
      }
      return tr;
    };

    Table.prototype.setup_header = function() {
      var header, thead, tr;
      thead = this.element.find("thead");
      if (thead) {
        header = this.constructHeader();
        tr = angular.element(thead).find("tr");
        tr.remove();
        return thead.append(header);
      }
    };

    Table.prototype.validateInput = function() {
      if (this.attributes.atPagination && this.attributes.atList) {
        throw "You can not specify a list if you have specified a Pagination. The list defined for the pagnination will automatically be used.";
      }
      if (!this.attributes.atPagination && !this.attributes.atList) {
        throw "Either a list or Pagination must be specified.";
      }
    };

    Table.prototype.create_table_setup = function(attributes) {
      if (attributes.atList) {
        return new StandardTableSetup(attributes);
      }
      if (attributes.atPagination) {
        return new PaginationTableSetup(attributes);
      }
    };

    Table.prototype.compile = function() {
      this.validateInput();
      this.setup_header();
      this.setup = this.create_table_setup(this.attributes);
      return this.setup.compile(this.element, this.attributes);
    };

    Table.prototype.setup_initial_sorting = function($scope) {
      var bd, _i, _len, _ref, _results;
      _ref = this.get_column_configurations();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bd = _ref[_i];
        if (bd.initialSorting) {
          if (!bd.attribute) {
            throw "initial-sorting specified without attribute.";
          }
        }
        $scope.predicate = bd.attribute;
        _results.push($scope.descending = bd.initialSorting === "desc");
      }
      return _results;
    };

    Table.prototype.post = function($scope, $element, $attributes) {
      this.setup_initial_sorting($scope);
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
      return this.setup.link($scope, $element, $attributes);
    };

    return Table;

  })();

  TableSetup = (function() {
    TableSetup.prototype.orderByExpression = "| orderBy:predicate:descending";

    TableSetup.prototype.limitToExpression = "| limitTo:fromPage() | limitTo:toPage()";

    function TableSetup() {}

    TableSetup.prototype.setupTr = function(element, repeatString) {
      var tbody, tr;
      tbody = element.find("tbody");
      tr = tbody.find("tr");
      tr.attr("ng-repeat", repeatString);
      return tbody;
    };

    (function(attributes) {
      if (attributes.atList) {
        return new StandardSetup(attributes);
      }
      if (attributes.atPagination) {
        return new PaginationSetup(attributes);
      }
    });

    return TableSetup;

  })();

  ColumnConfiguration = (function() {
    function ColumnConfiguration(body_markup, header_markup) {
      this.attribute = body_markup.attribute;
      this.title = body_markup.title;
      this.sortable = body_markup.sortable;
      this.width = body_markup.width;
      this.initialSorting = body_markup.initialSorting;
      if (header_markup) {
        this.custom_content = header_markup.custom_content;
        this.attributes = header_markup.attributes;
      }
    }

    ColumnConfiguration.prototype.create_element = function() {
      var th;
      th = angular.element(document.createElement("th"));
      return th.attr("style", "cursor: pointer;");
    };

    ColumnConfiguration.prototype.render_title = function(element) {
      return element.html(this.custom_content || this.title);
    };

    ColumnConfiguration.prototype.render_attributes = function(element) {
      var attribute, _i, _len, _ref, _results;
      if (this.custom_content) {
        _ref = this.attributes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attribute = _ref[_i];
          _results.push(element.attr(attribute.name, attribute.value));
        }
        return _results;
      }
    };

    ColumnConfiguration.prototype.render_sorting = function(element) {
      var icon;
      if (this.sortable) {
        element.attr("ng-click", "predicate = '" + this.attribute + "'; descending = !descending;");
        icon = angular.element("<i style='margin-left: 10px;'></i>");
        icon.attr("ng-class", "getSortIcon('" + this.attribute + "')");
        return element.append(icon);
      }
    };

    ColumnConfiguration.prototype.render_width = function(element) {
      return element.attr("width", this.width);
    };

    ColumnConfiguration.prototype.render_html = function() {
      var th;
      th = this.create_element();
      this.render_title(th);
      this.render_attributes(th);
      this.render_sorting(th);
      this.render_width(th);
      return th;
    };

    return ColumnConfiguration;

  })();

  DeclarativeTable = (function(_super) {
    __extends(DeclarativeTable, _super);

    function DeclarativeTable(element, attributes) {
      this.element = element;
      this.attributes = attributes;
    }

    DeclarativeTable.prototype.capitaliseFirstLetter = function(string) {
      if (string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
      } else {
        return "";
      }
    };

    DeclarativeTable.prototype.extractWidth = function(classes) {
      var width;
      width = /([0-9]+px)/i.exec(classes);
      if (width) {
        return width[0];
      } else {
        return "";
      }
    };

    DeclarativeTable.prototype.isSortable = function(classes) {
      var sortable;
      sortable = /(sortable)/i.exec(classes);
      if (sortable) {
        return true;
      } else {
        return false;
      }
    };

    DeclarativeTable.prototype.getInitialSorting = function(td) {
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

    DeclarativeTable.prototype.collect_header_markup = function(table) {
      var customHeaderMarkups, th, tr, _i, _len, _ref;
      customHeaderMarkups = {};
      tr = table.find("tr");
      _ref = tr.find("th");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        th = _ref[_i];
        th = angular.element(th);
        customHeaderMarkups[th.attr("at-attribute")] = {
          custom_content: th.html(),
          attributes: th[0].attributes
        };
      }
      return customHeaderMarkups;
    };

    DeclarativeTable.prototype.collect_body_markup = function(table) {
      var attribute, bodyDefinition, initialSorting, sortable, td, title, width, _i, _len, _ref;
      bodyDefinition = [];
      _ref = table.find("td");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        td = _ref[_i];
        td = angular.element(td);
        attribute = td.attr("at-attribute");
        title = td.attr("at-title") || this.capitaliseFirstLetter(td.attr("at-attribute"));
        sortable = td.attr("at-sortable") !== void 0 || this.isSortable(td.attr("class"));
        width = this.extractWidth(td.attr("class"));
        initialSorting = this.getInitialSorting(td);
        bodyDefinition.push({
          attribute: attribute,
          title: title,
          sortable: sortable,
          width: width,
          initialSorting: initialSorting
        });
      }
      return bodyDefinition;
    };

    DeclarativeTable.prototype.create_column_configurations = function() {
      var body_markup, column_configurations, header_markup, i, _i, _len;
      header_markup = this.collect_header_markup(this.element);
      body_markup = this.collect_body_markup(this.element);
      column_configurations = [];
      for (_i = 0, _len = body_markup.length; _i < _len; _i++) {
        i = body_markup[_i];
        column_configurations.push(new ColumnConfiguration(i, header_markup[i.attribute]));
      }
      return column_configurations;
    };

    DeclarativeTable.prototype.get_column_configurations = function() {
      return this.column_configurations || (this.column_configurations = this.create_column_configurations());
    };

    return DeclarativeTable;

  })(Table);

  StandardTableSetup = (function(_super) {
    __extends(StandardTableSetup, _super);

    function StandardTableSetup(attributes) {
      this.repeatString = "item in " + attributes.atList + " " + this.orderByExpression;
    }

    StandardTableSetup.prototype.compile = function(element, attributes, transclude) {
      return this.setupTr(element, this.repeatString);
    };

    StandardTableSetup.prototype.link = function() {};

    return StandardTableSetup;

  })(TableSetup);

  PaginationTableSetup = (function(_super) {
    __extends(PaginationTableSetup, _super);

    function PaginationTableSetup(attributes) {
      this.sortContext = attributes.atSortContext || "global";
      this.paginationName = attributes.atPagination;
      this.fillLastPage = attributes.atFillLastPage;
      if (this.sortContext === "global") {
        this.repeatString = "item in " + this.paginationName + ".atList " + this.orderByExpression + " " + this.limitToExpression;
      } else if (this.sortContext === "page") {
        this.repeatString = "item in " + this.paginationName + ".atList " + this.limitToExpression + " " + this.orderByExpression + " ";
      } else {
        throw "Invalid sort-context: " + this.sortContext + ".";
      }
    }

    PaginationTableSetup.prototype.compile = function(element, attributes, transclude) {
      var fillerTr, tbody, td, tdString, tds, _i, _len;
      tbody = this.setupTr(element, this.repeatString);
      if (typeof this.fillLastPage !== "undefined") {
        tds = element.find("td");
        tdString = "";
        for (_i = 0, _len = tds.length; _i < _len; _i++) {
          td = tds[_i];
          tdString += "<td>&nbsp;</td>";
        }
        fillerTr = angular.element(document.createElement("tr"));
        fillerTr.html(tdString);
        fillerTr.attr("ng-repeat", "item in " + this.paginationName + ".getFillerArray() ");
        tbody.append(fillerTr);
      }
    };

    PaginationTableSetup.prototype.link = function($scope, $element, $attributes) {
      var paginationName;
      paginationName = this.paginationName;
      $scope.fromPage = function() {
        if ($scope[paginationName]) {
          return $scope[paginationName].fromPage();
        }
      };
      $scope.toPage = function() {
        if ($scope[paginationName]) {
          return $scope[paginationName].atItemsPerPage;
        }
      };
    };

    return PaginationTableSetup;

  })(TableSetup);

}).call(this);
