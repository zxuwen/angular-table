# angular-table [![Build Status](https://travis-ci.org/samu/angular-table.png?branch=master)](https://travis-ci.org/samu/angular-table)

_work in progress!_

Angular directive which allows to declare sortable tables and to add
pagination with very little effort.

## Features
  * Makes columns sortable
  * Adds pagination in a plug-and-play manner
  * Implicitly renders cell contents by name convention and allows custom cell content if needed
  * Renders headers implicitly and allows custom header declarations if needed
  * Lets you define pagination options `items per page`, `maximum pages`, `sort context` and `fill last page`
  * 100% declarative, no code required in your controllers

Check out the [examples](http://samu.github.io/angular-table/examples.html) for a demo.

## Configuration

### Configurations for a table with pagination

The following configurations can be used inside the `<table>` tag and come into play when a pagination is used:

  * `at-items-per-page=integer` defines the maximum amount of items to be displayed per page.

  * `at-fill-last-page=string` fills up the remaining space of the last page of your table.

  * `at-maximum-pages=integer` comes in handy if you expect your list to contain a lot of entries.

  * `at-sort-context` allows to set the sorting behaviour to `'global'` or `'page'`.

These options can be configured by using a scope model, such as `at-items-per-page="yourScopeVariable"`. However,
you can also directly assign values, such as `at-items-per-page="5"`. In that case, `angular-table` will automatically
set up appropriate variables in your scope, prefixed with the id of the table, for example `$scope.tableId_itemsPerPage`.

### Column options

